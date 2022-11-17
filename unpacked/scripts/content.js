// const CODE_BLOCKS = document.querySelectorAll("pre.lang-py");
const CODE_BLOCKS = document.getElementsByClassName("lang-py");
const VERSIONS = {
  20:"Python 2.0",
  22:"Python 2.2",
  23:"Python 2.3",
  24:"Python 2.4",
  25:"Python 2.5",
  26:"Python 2.6",
  27:"Python 2.7",
  30:"Python 3.0",
  31:"Python 3.1",
  32:"Python 3.2",
  33:"Python 3.3",
  35:"Python 3.5",
  36:"Python 3.6",
  37:"Python 3.7",
  243:"Python 2.4.3",
  272:"Python 2.7.2",
};
const MOST_RECENT_VERSION = Math.max(...Object.keys(VERSIONS).map(k => k.slice(0, 2)));


// Wait for wasm module to load
Module.onRuntimeInitialized = () => {
// add selectors to all code blocks
for (let block of CODE_BLOCKS) {
    let text = block.firstChild.textContent;
    let formattedText = formatText(text);
    let resultJson = check_compliance(formattedText);
    let resultObj = JSON.parse(resultJson);
    addSelect(block,resultObj,formattedText);
}
}

// adds the select with functionality to the block
function addSelect(block,resultObj,formattedText, mostRecentVersion) {
    // Generate the buttons to select the various versions
    let select = document.createElement("select");
    let entries = Object.entries(VERSIONS);
    entries.sort();
    entries.reverse();
    for (const [ver_number, ver_string] of entries) {
      select.options.add(new Option(ver_string, ver_number));
    }
    // Add the outer border (usually seen on javascript snippets)
    // In order to preserve references the element is added side by side and then reordered
    block.className += " snippet-code-py";
    let snippetWrapper = document.createElement("div");
    block.parentNode.insertBefore(snippetWrapper, block);
    snippetWrapper.appendChild(block);
    snippetWrapper.className = "snippet-code";

    // Add the button below the snippet block
    let snippetResult = document.createElement("div");
    snippetResult.className = "snippet-result";
    let snippetCtas = document.createElement("div");
    snippetCtas.className = "snippet-ctas";
    let snippetResultLog = document.createElement("div");
    snippetResultLog.className = "s-code-block snippet-result-log";
    snippetResult.append(snippetCtas);
    snippetResult.append(snippetResultLog);
    snippetWrapper.append(snippetResult);

    // Add events and functions to drop-down menus
    select.addEventListener("change",function(){
        let index=this.selectedIndex;
        let selectedVersion = parseInt(this.options[index].value);
        displayInfo(snippetResultLog,resultObj,selectedVersion);
    });

    // copy formatted code
    select.addEventListener("click", () => navigator.clipboard.writeText(formattedText));
    setSelectStyle(select);
    snippetCtas.appendChild(select);
    displayInfo(snippetResultLog, resultObj, MOST_RECENT_VERSION);
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

    let verStr = "";
    for (let key in VERSIONS){
        let ver = parseInt(key);
        let value = VERSIONS[key];
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
    for(let i in resultObj){
        let version = resultObj[i].version;
        let other = resultObj[i].error;
        if((!other) && (version != selectedVersion)){
            let verString = String(resultObj[i].version);
            for(let v in VERSIONS){
                if(v == verString){
                    let verString = VERSIONS[v];
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

function displayInfo(resultBlock,resultObj,selectedVersion){
    let output_variable = document.createElement("div");
    let output_other = document.createElement("div");
    let noError = selectedInfo(resultObj,selectedVersion);
    let errInfo = getErrInfo(resultObj,selectedVersion);
    let otherInfo = otherVersions(resultObj,selectedVersion);
    let verStr = "";
    for (let key in VERSIONS){
        let ver = parseInt(key);
        let value = VERSIONS[key];
        if(ver == selectedVersion){
            verStr = value;
        }
    }
    if (noError){
            output_variable.className = "pyverdetector-no-errors";
            output_variable.innerText = "No errors for " + verStr +"!"
        }else{
            output_variable.className = "pyverdetector-errors";
            output_variable.innerText = errInfo;
        }
    output_other.innerText = otherInfo;
    resultBlock.innerHTML ="";
    resultBlock.appendChild(output_variable);
    resultBlock.appendChild(output_other);
}

//display by alert
function dispalyAlert(resultObj,selectedVersion){
    let noError = selectedInfo(resultObj,selectedVersion);
    let errInfo = getErrInfo(resultObj,selectedVersion);
    let otherInfo = otherVersions(resultObj,selectedVersion);
    let verStr = "";
    for (let key in VERSIONS){
        let ver = parseInt(key);
        let value = versionsOb[key];
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
