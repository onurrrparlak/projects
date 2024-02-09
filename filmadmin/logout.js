function logout() {
    localStorage.setItem("loggedIn", "false");
    window.top.location.href = "login.html";
  
}
