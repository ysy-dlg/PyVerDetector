const CODE_BLOCKS = document.getElementsByTagName("pre");
const BODY = document.body;


// add buttons to all code blocks
for (let block of CODE_BLOCKS) {
    addSelect(block);
}

// adds the select with functionality to the block
function addSelect(block) {
    let text = block.firstChild.textContent;
    let select = document.createElement("select");
    // document.body.appendChild(select);
    let output_selected = document.createElement("div");
    let output_errorInfo = document.createElement("div");
    let output_other = document.createElement("div");
    output_selected.style.backgroundColor="#CFECEC"; 
    output_errorInfo.style.backgroundColor="#F9F400"; 
    output_other.style.backgroundColor="#4CC417"; 
    let avaInfo = "";
    let errInfo = "";
    let otherInfo = "";
    select.options.add(new Option("Python Version",""));
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

    // selector check event
    select.addEventListener('change',function(){
        resultJson = [
            {"version":20,"error":"syntax error, unexpected PY20_STRING, expecting PY20_RPAR","line":2,"column":12},
            {"version":22,"error":"syntax error, unexpected PY22_STRING, expecting PY22_RPAR","line":2,"column":12},
            {"version":23,"error":"syntax error, unexpected PY23_STRING, expecting PY23_RPAR","line":2,"column":12},
            {"version":243,"error":"syntax error, unexpected PY243_STRING, expecting PY243_RPAR","line":2,"column":12},
            {"version":24,"error":"syntax error, unexpected PY24_STRING, expecting PY24_RPAR","line":2,"column":12},
            {"version":25,"error":"syntax error, unexpected PY25_STRING, expecting PY25_RPAR","line":2,"column":12},
            {"version":26,"error":"syntax error, unexpected PY26_STRING, expecting PY26_RPAR","line":2,"column":12},
            {"version":272,"error":"syntax error, unexpected PY272_STRING, expecting PY272_RPAR","line":2,"column":12},
            {"version":27,"error":"syntax error, unexpected PY27_STRING, expecting PY27_RPAR","line":2,"column":12},
            {"version":30,"error":"syntax error, unexpected PY30_STRING, expecting PY30_RPAR","line":2,"column":12},
            {"version":31,"error":"syntax error, unexpected PY31_STRING, expecting PY31_RPAR","line":2,"column":12},
            {"version":32,"error":"syntax error, unexpected PY32_STRING, expecting PY32_RPAR","line":2,"column":12},
            {"version":33,"error":"syntax error, unexpected PY33_STRING, expecting PY33_RPAR","line":2,"column":12},
            // {"version":35,"error":"syntax error, unexpected PY35_STRING, expecting PY35_RPAR","line":2,"column":12},
            {"version":35,"error":"","line":2,"column":12},
            {"version":36,"error":"","line":4,"column":1},
        ];
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

    // add the functionality and set the style
    select.addEventListener("click", function() {
        navigator.clipboard.writeText(text)
    });

    setSelectStyle(select, block.getBoundingClientRect());

    // adds a newline for spacing, add the select
    block.innerHTML += "<br>\n";
    block.appendChild(select);
}

// function addOption(id){
//     var obj=document.getElementById(id);
//     obj.options.add(new Option("Python Version",0));
//     obj.options.add(new Option("ver2.0", 20));
//     obj.options.add(new Option("ver2.2", 22));
//     obj.options.add(new Option("ver2.3", 23));
//     obj.options.add(new Option("ver2.4", 24));
//     obj.options.add(new Option("ver2.4.3", 243));
//     obj.options.add(new Option("ver2.5", 25));
//     obj.options.add(new Option("ver2.6", 26));
//     obj.options.add(new Option("ver2.7", 27));
//     obj.options.add(new Option("ver2.7.2", 272));
//     obj.options.add(new Option("ver3.0", 30));
//     obj.options.add(new Option("ver3.1", 31));
//     obj.options.add(new Option("ver3.2", 32));
//     obj.options.add(new Option("ver3.3", 33));
//     obj.options.add(new Option("ver3.5", 35));
//     obj.options.add(new Option("ver3.6", 36));
//     }
  



// sets the style for the select and position with the bounding box of the block
function setSelectStyle(select, boundingBox) {
    // select.innerHTML = "Display";
    select.classList.add("__so-select");
    
    //color
    // select.style.backgroundColor="#E5E4E2"


    // using stack overflow style
    select.classList.add("s-btn");
    select.classList.add("s-btn__primary");
}


// The code is copied directly from the terminal with the accompanying ">>>" and "..."
function formatText(text){
    return text;
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

