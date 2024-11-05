// ==UserScript==
// @name         afking coins
// @namespace    
// @version      2024-10-20
// @description  try to take over the world!
// @author       tlzytb
// @match        https://frac.gg/afk
// @icon         data:image/gif;base64,R0lGODlhAQABAAAAACH5BAEKAAEALAAAAAABAAEAAAICTAEAOw==
// @grant        none
// ==/UserScript==

(function() {
    // afk check
const discordWebhookUrl = 'https://discord.com/api/webhooks/1283057585494298744/2Y7MJmZHBZbbKBZxfRVjGKEI1JaslSnIy6i17kr9nZ7blWXgM27we6jBgm4PhAwFacFb';

function sendDiscordWebhook(message) {
    fetch(discordWebhookUrl, {
        method: 'POST',
        headers: {
            'Content-Type': 'application/json'
        },
        body: JSON.stringify({ content: message })
    }).then(response => {
        if (!response.ok) {
            console.error("error:", response.statusText);
        }
    }).catch(error => {
        console.error("error:", error);
    });
}

function check() {
  const currentTimeStr = document.getElementById("timeActive").innerHTML;
  const earningRateStr = document.getElementById("earningRate").innerHTML;
  const [minutesStr, secondsStr] = currentTimeStr.split(' ');
  const minutes = parseInt(minutesStr.slice(0, -1));
  const seconds = parseInt(secondsStr.slice(0, -1));
  const totalMinutes = minutes + seconds / 60;
  const earningRate = parseFloat(earningRateStr);
  const totalEarnings = totalMinutes * earningRate;
  const message = `=====================\nAFK Time: ${currentTimeStr}\nEarning Rate: ${earningRateStr}\nTotal Earnings: ${totalEarnings}`;
  console.log(message);
  sendDiscordWebhook(message);
}

setInterval(check, 5000);
})();
