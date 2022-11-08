const CODE_BLOCKS = document.getElementsByTagName("pre");
const BODY = document.body;

// add buttons to all code blocks
for (let block of CODE_BLOCKS) {
    addSelect(block);
}

document.querySelectorAll('select').forEach((val, ind) => {
    val.id = "select" + (ind + 1);
    addOption(val.id);
  })

// adds the select with functionality to the block
function addSelect(block) {
    let text = block.firstChild.textContent;
    let select = document.createElement("select");
    document.body.appendChild(select);
    let output_selected = document.createElement("div")
    let output_errorInfo = document.createElement("div")
    let output_other = document.createElement("div")


    //selector check event
    select.addEventListener('change',function(){
        // alert('changed');
        output_selected.innerText = "ver3.1ver3.1ver3.1ver3.1ver3.1ver3.1ver3.1";
        output_errorInfo.innerText = "ver3.2ver3.2ver3.2ver3.2ver3.2ver3.2ver3.2";
        output_other.innerText = "ver4.1ver4.1ver4.1ver4.1ver4.1ver4.1ver4.1";
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

function addOption(id){
    var obj=document.getElementById(id);
    obj.options.add(new Option("Python Version",""));
    obj.options.add(new Option("ver2.0", 20));
    obj.options.add(new Option("ver2.2", 22));
    obj.options.add(new Option("ver2.3", 23));
    obj.options.add(new Option("ver2.4", 24));
    obj.options.add(new Option("ver2.4.3", 243));
    obj.options.add(new Option("ver2.5", 25));
    obj.options.add(new Option("ver2.6", 26));
    obj.options.add(new Option("ver2.7", 27));
    obj.options.add(new Option("ver2.7.2", 272));
    obj.options.add(new Option("ver3.0", 30));
    obj.options.add(new Option("ver3.1", 31));
    obj.options.add(new Option("ver3.2", 32));
    obj.options.add(new Option("ver3.3", 33));
    obj.options.add(new Option("ver3.5", 35));
    obj.options.add(new Option("ver3.6", 36));
    }
  



// sets the style for the select and position with the bounding box of the block
function setSelectStyle(select, boundingBox) {
    // select.innerHTML = "Display";
    select.classList.add("__so-select");

    // using stack overflow style
    select.classList.add("s-btn");
    select.classList.add("s-btn__primary");
}


// The code is copied directly from the terminal with the accompanying ">>>" and "..."
function formatText(text){
    var reg2 = new RegExp("\n"); // 不加'g'，仅删除字符串里第一个"a"
    var a2 = text.replace(reg2,"");
    return a2
}

//Get the error line number, find the line, output [error: ERR_MSG in LINE]
function getErrLine(){}

//display
//selected version: available/ not available
//error_info: Get the error line number, find the line, output [error: ERR_MSG in LINE]
//other available versions：
function display(){}



