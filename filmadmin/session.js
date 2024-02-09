document.addEventListener("DOMContentLoaded", function () {
    var loggedIn = localStorage.getItem("loggedIn");

    // Check if user is not logged in and redirect to login page
    if (!loggedIn || loggedIn !== "true") {
        window.top.location.href = "login.html";
    }
});
