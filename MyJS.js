var autho = [48, 49, 50, 51, 52, 53, 54, 55, 56, 57, // les chiffres de 0-9
             96, 97, 98, 99, 100, 101, 102, 103, 104, 105, // ligne pour les 0-9 du pad
             65, 66, 67, 68, 69, 70, 71, 72, 73, 74, 75, 76, 77, 78, 79, 80, 81,
             82, 83, 84, 85, 86, 87, 88, 89, 90, // les lettres de a-z
             186, 187, 188, 189, 190, 192, 222,
             9, 13, 32, 37, 38, 39, 40, 45, 46, 8]; // la ponctuation 

function disableTouch(e) { if (!autho.includes((e.which || e.keyCode))) e.preventDefault(); }



shinyjs.init = function() {
  $(document).on("keydown", disableTouch);
};

shinyjs.toggleFullScreen = function() {
    var element = document.documentElement,
      enterFS = element.requestFullscreen || element.msRequestFullscreen || element.mozRequestFullScreen || element.webkitRequestFullscreen,
      exitFS = document.exitFullscreen || document.msExitFullscreen || document.mozCancelFullScreen || document.webkitExitFullscreen;
    if (!document.fullscreenElement && !document.msFullscreenElement && !document.mozFullScreenElement && !document.webkitFullscreenElement) {
      enterFS.call(element);
    }/* else {
      exitFS.call(document);
    }*/
};


