const CODE_BLOCKS = document.getElementsByTagName("pre");


// Wait for wasm module to load
Module.onRuntimeInitialized = () => {
// add selectors to all code blocks
for (let block of CODE_BLOCKS) {
    var text = block.firstChild.textContent;
    var formattedText = formatText(text);
    var resultJson = check_compliance(formattedText);
    var resultObj = JSON.parse(resultJson);
    let selectedVersion = 36;
    displayInfo(block,resultObj,selectedVersion);
    addSelect(block,resultObj,formattedText);
    
}
}

// adds the select with functionality to the block
function addSelect(block,resultObj,formattedText) {
    // let text = block.firstChild.textContent;
    let select = document.createElement("select");

    select.options.add(new Option("ver3.6", 36));
    select.options.add(new Option("ver3.5", 35));
    select.options.add(new Option("ver3.3", 33));
    select.options.add(new Option("ver3.2", 32));
    select.options.add(new Option("ver3.1", 31));
    select.options.add(new Option("ver3.0", 30));
    select.options.add(new Option("ver2.7.2", 272));
    select.options.add(new Option("ver2.7", 27));
    select.options.add(new Option("ver2.6", 26));
    select.options.add(new Option("ver2.5", 25));
    select.options.add(new Option("ver2.4.3", 243));
    select.options.add(new Option("ver2.4", 24));
    select.options.add(new Option("ver2.3", 23));
    select.options.add(new Option("ver2.2", 22));
    select.options.add(new Option("ver2.0", 20));

    // let formattedText = formatText(text);
    // let resultJson = check_compliance(formattedText);
    // let resultObj = JSON.parse(resultJson);


    // selector check event
    select.addEventListener("change",function(){
        let index=this.selectedIndex;

        let selectedVersion = parseInt(this.options[index].value);
        
       
        //alert(selectedVersion);
        //alert(resultJson);

        // displayInfo(block,resultObj,selectedVersion);
        dispalyAlert(resultObj,selectedVersion);



    });

    // select.addEventListener("change",displayInfo(block,resultObj,parseInt(select.options[select.selectedIndex].value)));

    // copy
    select.addEventListener("click", () => navigator.clipboard.writeText(formattedText));

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

//Check if the selected version is ok
function selectedInfo(resultObj,selectedVersion){
    let noError = false;
    for(let i in resultObj){
        let version = resultObj[i].version;
        let error = resultObj[i].error;
        if(version == selectedVersion){
            if(error == ""){
                noError = true;
            }
        }

    }
    return noError;
}

//get error information for selected version
function getErrInfo(resultObj, selectedVersion){

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
    let verStr = "";
    for (let key in versionsObj){
        let ver = parseInt(key);
        let value = versionsObj[key];
        if(ver == selectedVersion){
            verStr = value;
        }
    }
    let errInfo = "ERROR for " + verStr +": ";


    for(let i in resultObj){
        if(resultObj[i].version == selectedVersion && resultObj[i].error != ""){
            errInfo = errInfo + "At line " + resultObj[i].line + " " + resultObj[i].error;
            errInfo = errInfo.split(/PY[0-9]+_([A-Z_]+)/)
            errInfo.forEach(function(item, index, array) {
              if(tokens[item]!==undefined) {
                array[index] = tokens[item];
              }
            });
            errInfo = errInfo.join("")
        }
    }
return errInfo;
}


//Get other versions can be used for code snippet
function otherVersions(resultObj,selectedVersion){
    let otherVersionsArray = [];
    let otherInfo = "";
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
    for(let i in resultObj){
        let version = resultObj[i].version;
        let other = resultObj[i].error;
        if((!other) && (version != selectedVersion)){
            let verString = String(resultObj[i].version);
            for(let v in versionsObj){
                if(v == verString){
                    let verString = versionsObj[v];
                    otherVersionsArray.push(verString)
                }
            }
        }
    }
    if(otherVersionsArray.length > 0){
        let versionJoin = otherVersionsArray.join(",")
        otherInfo = "Also works for: " + versionJoin;
    }
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

//display by span
function displayInfo(block,resultObj,selectedVersion){
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

    let output_variable = document.createElement("span");
    let output_other = document.createElement("sapn");

    
    let noError = selectedInfo(resultObj,selectedVersion);
    let errInfo = getErrInfo(resultObj,selectedVersion);
    let otherInfo = otherVersions(resultObj,selectedVersion);
    let verStr = "";
    for (let key in versionsObj){
        let ver = parseInt(key);
        let value = versionsObj[key];
        if(ver == selectedVersion){
            verStr = value;
        }
    }
    
    if (noError){
            output_variable.style.backgroundColor = "#98FF98";
            output_variable.innerText = "No errors for " + verStr +"!"
        }else{
            output_variable.style.backgroundColor = "#F9A7B0";
            output_variable.innerText = errInfo;
        }

    output_other.innerText = otherInfo;

    block.innerHTML += "<br>\n";
    block.appendChild(output_variable);
    block.innerHTML += "\n";
    block.appendChild(output_other);

}

//display by alert
function dispalyAlert(resultObj,selectedVersion){
    let noError = selectedInfo(resultObj,selectedVersion);
    let errInfo = getErrInfo(resultObj,selectedVersion);
    let otherInfo = otherVersions(resultObj,selectedVersion);

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
    let verStr = "";
    for (let key in versionsObj){
        let ver = parseInt(key);
        let value = versionsObj[key];
        if(ver == selectedVersion){
            verStr = value;
        }
    }

    if (noError){
            alert("\n"+ "No errors for " + verStr +"!\n\n" + otherInfo);
        }else{
            alert(errInfo + otherInfo);
        }
}
