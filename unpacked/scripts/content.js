const CODE_BLOCKS = document.getElementsByTagName("pre");


// Wait for wasm module to load
Module.onRuntimeInitialized = () => {
// add selectors to all code blocks
for (let block of CODE_BLOCKS) {
    addSelect(block);
}
}

// adds the select with functionality to the block
function addSelect(block) {
    let text = block.firstChild.textContent;
    let select = document.createElement("select");
    let output_selected = document.createElement("div");
    let output_errorInfo = document.createElement("div");
    let output_other = document.createElement("div");
    output_selected.style.backgroundColor="#CFECEC"; 
    output_errorInfo.style.backgroundColor="#F9F400"; 
    output_other.style.backgroundColor="#4CC417"; 
    let avaInfo = "";
    let errInfo = "";
    let otherInfo = "";
    select.options.add(new Option("Select Python Version",""));
    select.options.add(new Option("ver2.0", 20));
    select.options.add(new Option("ver2.2", 22));
    select.options.add(new Option("ver2.3", 23));
    select.options.add(new Option("ver2.4", 24));
    select.options.add(new Option("ver2.4.3", 243));
    select.options.add(new Option("ver2.5", 25));
    select.options.add(new Option("ver2.6", 26));
    select.options.add(new Option("ver2.7", 27));
    select.options.add(new Option("ver2.7.2", 272));
    select.options.add(new Option("ver3.0", 30));
    select.options.add(new Option("ver3.1", 31));
    select.options.add(new Option("ver3.2", 32));
    select.options.add(new Option("ver3.3", 33));
    select.options.add(new Option("ver3.5", 35));
    select.options.add(new Option("ver3.6", 36));
    let formattedText = formatText(text);
    let resultJson = check_compliance(formattedText);

    // selector check event
    select.addEventListener('change',function(){
        let index=this.selectedIndex;
        let seletedVersion = this.options[index].value;
        // alert(seletedVersion);
        avaInfo = selectedAvailabilityInfo(resultJson,seletedVersion);
        output_selected.innerText = avaInfo;
        errInfo = getErrInfo(resultJson,seletedVersion);
        output_errorInfo.innerText = errInfo;
        otherInfo = otherAvailable(resultJson,seletedVersion);
        output_other.innerText = otherInfo;

        block.innerHTML += "<br>\n";
        block.appendChild(output_selected);
        block.appendChild(output_errorInfo);
        block.appendChild(output_other);
    });

    // copy
    select.addEventListener("click", function() {
        navigator.clipboard.writeText(textFormatted);
    });

    setSelectStyle(select);

    // adds a newline for spacing, add the select
    block.innerHTML += "<br>\n";
    block.appendChild(select);
}


// sets the style for the select
function setSelectStyle(select) {  
    //color
    // select.style.backgroundColor="#E5E4E2"

    // using stack overflow style
    select.classList.add("s-btn");
    select.classList.add("s-btn__primary");
}


// The code is copied directly from the terminal with the accompanying ">>>" and "..."
function formatText(text){
    let codeLines = [];
    let codeLines_Formatted = [];
    let keyStr1 = ">>>";
    let keyStr2 = "...";
    let text_new = "";
    codeLines = text.split(/\n/); // Recognition by line feed
    // codeLines.forEach((item, index) => { // Delete empty items
    //     if (!item) {
    //         codeLines.splice(index, 1);
    //         }
    // })
    let num = codeLines.length;
    let i = 0;
    for(i; i < num; i++){
        let str = codeLines[i];
        if(str.indexOf(keyStr1) == 0){
            let str_new = str.slice(4);
            codeLines_Formatted.push(str_new);
            break;
        }else{
            codeLines_Formatted.push(str);
        }
    }

    let num_new = codeLines.length - i - 1;
    let j = i + 1;
    for(j; j<num_new; j++){
        let str = codeLines[j];
        if(str.indexOf(keyStr1) == 0 || str.indexOf(keyStr2) == 0){
            if(str.indexOf(keyStr1) == 0){
                let str_new = str.slice(4);
                codeLines_Formatted.push(str_new);
            }else{
                let str_new = str.slice(3);
                codeLines_Formatted.push(str_new);
            }
        }else{
            codeLines_Formatted.push("");
        }

    }


    text_new = codeLines_Formatted.join("\n");

    return text_new;
}

//Check if the selected version is available
function selectedAvailabilityInfo(resultJson,selectedVersion){
    let availability = false;
    let avaInfo = "selected version: ";
    for(let i in resultJson){
        if(resultJson[i].version == selectedVersion){
            if(!resultJson[i].error){
                availability = true;
            }
        }
    }
    if(availability){
        avaInfo = avaInfo + "available";
    }else{
        avaInfo = avaInfo + "not available";
    }
    return avaInfo;
}


//Get the error line number, find the line, output [error: ERR_MSG in LINE]
function getErrInfo(resultJson,selectedVersion){
    let errInfo = "error: ";
    for(let i in resultJson){
        if(resultJson[i].version == selectedVersion){
            errInfo = errInfo + "[" + resultJson[i].error +"]" + " in the line: " + resultJson[i].line;
        }
    }
return errInfo;
}


//Get other available versions
function otherAvailable(resultJson,selectedVersion){
    let otherVersionsArray = [];
    let otherInfo = "other available versions: ";
    let versionsObj = {20:"ver2.0", 
                       22:"ver2.2", 
                       23:"ver2.3",
                       24:"ver2.4",
                       243:"ver2.4.3",
                       25:"ver2.5",
                       26:"ver2.6",
                       27:"ver2.7",
                       272:"ver2.7.2",
                       30:"ver3.0",
                       31:"ver3.1",
                       32:"ver3.2",
                       33:"ver3.3",
                       35:"ver3.5",
                       36:"ver3.6"};
    for(let i in resultJson){
        let version = resultJson[i].version;
        let ava = resultJson[i].error;
        if((!ava) && (version != selectedVersion)){
            let verString = resultJson[i].version.toString();
            // alert("versting"+verString)
            for(let v in versionsObj){
                if(v == verString){
                    let verString = versionsObj[v];
                    // alert("versting"+verString)
                    otherVersionsArray.push(verString)
                }
            }
        }
    }
    let versionJoin = otherVersionsArray.join(",")
    otherInfo = otherInfo + versionJoin;
    return otherInfo;
}


//Remove the extra indent at the beginning of the line
function delIndent(text){
    let codeLines = [];
    let codeLines_Formatted = [];
    let text_new = "";
    let indexArr = [];
    codeLines = text.split(/\n/); // Recognition by line feed
    let num = codeLines.length;
    let i = 0;
    for(i; i<num; i++){
        let str = codeLines[i];
        if(str.length > 0){
            let index = str.search(/\S|$/)
            indexArr.push(index);
        }
    }
    let minIndent = arrayMin(indexArr);
    let j = 0;
    for(j; j<num; j++){
        let str = codeLines[j];
        if(str.length > 0){
            let str_new = str.slice(minIndent)
            codeLines_Formatted.push(str_new);
        }else{
            codeLines_Formatted.push("");
        }
    }
    text_new = codeLines_Formatted.join("\n");
    return text_new;
}

//Get the minimum value of the array
function arrayMin(arrs){
    var min = arrs[0];
    for(var i = 1, ilen = arrs.length; i < ilen; i+=1) {
        if(arrs[i] < min) {
            min = arrs[i];
        }
    }
    return min;
}
