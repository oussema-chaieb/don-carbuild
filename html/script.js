function playsound(table) {
  var file = table["file"];
  var volume = table["volume"];
  var audioPlayer = null;
  if (audioPlayer != null) {
    audioPlayer.pause();
  }
  if (volume == undefined) {
    volume = 0.2;
  }
  audioPlayer = new Audio("./audio/" + file + ".ogg");
  audioPlayer.volume = volume;
  audioPlayer.play();
}

function countObject(ob) {
  var c = 0;
  for (const i in ob) {
    c = c + 1;
  }
  return c;
}

function Progress(status) {
  var max = 0;
  var value = 0;
  for (const i in status) {
    if (typeof status[i] == "object") {
      var parts = status[i];
      for (const val in parts) {
        if (parts[val] <= 0) {
          value = value + 1;
        }
        max = max + 1;
      }
    } else {
      if (status[i] == 0) {
        value = value + 1;
      }
      max = max + 1;
    }
  }
  return ((value / max) * 100).toFixed(2);
}

const canvas = document.getElementById("progress-canvas");
const ctx = canvas.getContext("2d");

function drawProgress(progress) {
  const centerX = canvas.width / 2;
  const centerY = canvas.height / 2;
  const radius = canvas.width / 2 - 10; // Adjusted for padding

  ctx.clearRect(0, 0, canvas.width, canvas.height);

  // Create a transparent grey circle
  ctx.beginPath();
  ctx.arc(centerX, centerY, radius, 0, Math.PI * 2);
  ctx.strokeStyle = "rgba(192, 192, 192, 0.7)"; // Transparent grey color
  ctx.lineWidth = 10;
  ctx.stroke();

  // Create a gradient color for progress
  const gradient = ctx.createLinearGradient(0, 0, canvas.width, canvas.height);
  gradient.addColorStop(0, "#e74c3c");
  gradient.addColorStop(0.5, "#f39c12");
  gradient.addColorStop(1, "#2ecc71");

  // Draw the progress arc with a gradient
  const endAngle = (progress / 100) * Math.PI * 2;
  ctx.beginPath();
  ctx.lineCap = "round";
  ctx.arc(centerX, centerY, radius, 0, endAngle);
  ctx.strokeStyle = gradient;
  ctx.lineWidth = 10;
  ctx.stroke();

  // Create a smooth animation effect
  const animationSteps = 100;
  let step = 0;
  const stepSize = (endAngle - 0) / animationSteps;

  const animate = () => {
    if (step < animationSteps) {
      step++;
      ctx.clearRect(0, 0, canvas.width, canvas.height);

      // Redraw the transparent grey circle
      ctx.beginPath();
      ctx.arc(centerX, centerY, radius, 0, Math.PI * 2);
      ctx.strokeStyle = "rgba(192, 192, 192, 0.7)";
      ctx.lineWidth = 10;
      ctx.stroke();

      // Redraw the progress arc with the gradient
      ctx.beginPath();
      ctx.arc(centerX, centerY, radius, 0, step * stepSize);
      ctx.strokeStyle = gradient;
      ctx.lineWidth = 10;
      ctx.stroke();
      requestAnimationFrame(animate);
    }
  };

  animate();
}

window.addEventListener("message", function (event) {
  var data = event.data;
  if (event.data.type == "project_status") {
    if (event.data.show) {
      document.getElementById("perf").style.display = "block";
      var info = event.data.info;
      if (info) {
        document.getElementById("model").innerHTML = info.model;
        document.getElementById("category").innerHTML = info.category;
      }
    } else {
      document.getElementById("perf").style.display = "none";
    }
    if (event.data.status) {
      const status = event.data.status;
      document.getElementById("progress").innerHTML =
        parseInt(Progress(status)) + " %";
      drawProgress(Progress(status));
      for (const i in status) {
        //console.log(i)
        if (typeof status[i] == "object") {
          var parts = status[i];
          var max = countObject(parts);
          var value = 0;
          for (const val in parts) {
            if (parts[val] <= 0) {
              value = value + 1;
            }
          }
          //console.log(value/max*100,i)
          document.getElementById(i).style.width =
            "" + (value / max) * 100 + "%";
        } else {
          //console.log(''+status[i] !== 1 && 100 || 0+'',i)
          var val = 100;
          if (status[i] == 1) {
            val = 0;
          }
          document.getElementById(i).style.width = "" + val + "%";
        }
      }
    }
  } else if (event.data.type == "spawn") {
    if (event.data.show) {
      document.getElementById("instr").style.display = "block";
    } else {
      document.getElementById("instr").style.display = "none";
    }
  }
});
