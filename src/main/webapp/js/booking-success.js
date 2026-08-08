// =====================================
// RentEasy Booking Success Page
// =====================================

// Copy Pickup OTP
function copyOTP() {

    const otp = document.getElementById("pickupOTP").innerText.trim();

    navigator.clipboard.writeText(otp)
        .then(function () {

            alert("Pickup OTP copied successfully!");

        })
        .catch(function () {

            const temp = document.createElement("textarea");
            temp.value = otp;
            document.body.appendChild(temp);

            temp.select();
            document.execCommand("copy");

            document.body.removeChild(temp);

            alert("Pickup OTP copied successfully!");

        });

}



// Download Receipt

function downloadReceipt() {

    window.print();

}



// Share Booking

function shareBooking() {

    if (navigator.share) {

        navigator.share({

            title: "RentEasy Booking",

            text:
                "My booking has been confirmed successfully on RentEasy.",

            url: window.location.href

        });

    }

    else {

        navigator.clipboard.writeText(window.location.href);

        alert("Booking link copied to clipboard.");

    }

}



// Smooth Page Load

window.addEventListener("load", function () {

    document.body.style.opacity = "1";

});



// Scroll Animation

const observer = new IntersectionObserver(function (entries) {

    entries.forEach(function (entry) {

        if (entry.isIntersecting) {

            entry.target.classList.add("show-card");

        }

    });

}, {

    threshold: 0.15

});



document.querySelectorAll(".card").forEach(function (card) {

    observer.observe(card);

});



// Back To Top Button

const topBtn = document.createElement("button");

topBtn.innerHTML = "↑";

topBtn.id = "topButton";

document.body.appendChild(topBtn);



topBtn.style.position = "fixed";
topBtn.style.right = "20px";
topBtn.style.bottom = "20px";
topBtn.style.width = "45px";
topBtn.style.height = "45px";
topBtn.style.borderRadius = "50%";
topBtn.style.border = "none";
topBtn.style.background = "#198754";
topBtn.style.color = "#fff";
topBtn.style.fontSize = "22px";
topBtn.style.display = "none";
topBtn.style.cursor = "pointer";
topBtn.style.zIndex = "9999";
topBtn.style.boxShadow = "0 8px 20px rgba(0,0,0,.25)";



window.addEventListener("scroll", function () {

    if (window.scrollY > 300) {

        topBtn.style.display = "block";

    }

    else {

        topBtn.style.display = "none";

    }

});



topBtn.addEventListener("click", function () {

    window.scrollTo({

        top: 0,

        behavior: "smooth"

    });

});



// Card Hover Effect

document.querySelectorAll(".card").forEach(function (card) {

    card.addEventListener("mouseenter", function () {

        card.style.transition = ".3s";

        card.style.transform = "translateY(-5px)";

    });



    card.addEventListener("mouseleave", function () {

        card.style.transform = "translateY(0px)";

    });

});



// Auto Hide Alerts

setTimeout(function () {

    document.querySelectorAll(".alert").forEach(function (alertBox) {

        alertBox.style.transition = ".5s";

        alertBox.style.opacity = "0";

    });

}, 12000);



// Console Message

console.log("RentEasy Booking Success Page Loaded Successfully");