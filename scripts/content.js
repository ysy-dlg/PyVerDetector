const CODE_BLOCKS = document.getElementsByTagName("pre")
const BODY = document.body

// add buttons to all code blocks
for (let block of CODE_BLOCKS) {
    addSelect(block)
}

document.querySelectorAll('select').forEach((val, ind) => {
    val.id = "select" + (ind + 1);
    addOption(val.id)
  })

// adds the button with functionality to the block
function addSelect(block) {
    let text = block.firstChild.textContent
    let select = document.createElement("select")
    document.body.appendChild(select);

    // add the functionality and set the style
    select.addEventListener("click", () => navigator.clipboard.writeText(text))
    setSelectStyle(select, block.getBoundingClientRect())

    // adds a newline for spacing, add the button
    block.innerHTML += "<br>\n"
    block.appendChild(select)
}

function addOption(id){
    var obj=document.getElementById(id);
    obj.options.add(new Option("Python Version",""));
    obj.options.add(new Option("ver2.0","20"));
    obj.options.add(new Option("ver2.2","22"));
    obj.options.add(new Option("ver2.4","24"));
    obj.options.add(new Option("ver2.5","25"));
    obj.options.add(new Option("ver2.6","26"));
    obj.options.add(new Option("ver2.7","27"));
    obj.options.add(new Option("ver3.0","30"));
    obj.options.add(new Option("ver3.1","31"));
    obj.options.add(new Option("ver3.3","33"));
    obj.options.add(new Option("ver3.5","35"));
    obj.options.add(new Option("ver3.6","36"));
    }

// sets the style for the button and position with the bounding box of the block
function setSelectStyle(select, boundingBox) {
    select.innerHTML = "Display"
    select.classList.add("__so-display-button")

    // using stack overflow style
    select.classList.add("s-btn")
    select.classList.add("s-btn__primary")
}
