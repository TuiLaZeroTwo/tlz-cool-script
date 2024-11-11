// ==UserScript==
// @name         afking coins
// @namespace    
// @version      2024-10-20
// @description  try to take over the world!
// @author       tlzytb
// @match        https://frac.gg/afk
// @icon         https://cdn.discordapp.com/avatars/339831176762097664/f8204747043c075a9a8e9a2375565330.png
// @grant        none
// ==/UserScript==

(function() {
    // afk check
const discordWebhookUrl = '';

    // embed
function sendD(embed) {
    fetch(discordWebhookUrl, {
      method: 'POST',
      headers: {
        'Content-Type': 'application/json'
      },
      body: JSON.stringify({ embeds: [embed] })
    }).then(response => {
      if (!response.ok) {
        console.error("error:",
 response.statusText);
      }
    }).catch(error => {
      console.error("error:", error);
    });
  }

let isConnected = true;

function check() {
    //check function
    const currentTimeStr = document.getElementById("timeActive").innerHTML;
    const earningRateStr = document.getElementById("earningRate").innerHTML;
    const [minutesStr, secondsStr] = currentTimeStr.split(' ');
    const minutes = parseInt(minutesStr.slice(0, -1));
    const seconds = parseInt(secondsStr.slice(0, -1));
    const totalMinutes = minutes + seconds / 60;
    const earningRate = parseFloat(earningRateStr);
    const totalEarnings = totalMinutes * earningRate;

    const embed = {
      title: "AFK Stats",
      color: 0x00ffff,
      fields: [
        { name: "AFK Time", value: currentTimeStr, inline: true },
        { name: "Earning Rate", value: earningRateStr, inline: true },
        { name: "Total Earnings", value: totalEarnings.toFixed(2), inline: true },
      ],
      timestamp: new Date(),
    };
    //Disconnected check
    window.addEventListener('unload', () => {
    if (isConnected) {
      isConnected = false;
      sendD({
        title: "Disconnected",
        color: 0xff0000,
        description: `Total coins earned ${totalEarnings.toFixed(2)} Frac`
      });
    }
  });
    //credit
    const message = `say hi to tlz`;
    console.log(message);
    sendD(embed);
  }

  setInterval(check, 5000);
})();
