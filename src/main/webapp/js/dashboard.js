const menuBtn = document.getElementById("menuToggle");
const sidebar = document.getElementById("sidebar");
const content = document.querySelector(".main-content");

menuBtn.onclick=function(){

    sidebar.classList.toggle("active");

    content.classList.toggle("shift");

}