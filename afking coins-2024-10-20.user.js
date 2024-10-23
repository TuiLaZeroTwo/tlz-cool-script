// ==UserScript==
// @name         afking coins
// @namespace    
// @version      2024-10-20
// @description  try to take over the world!
// @author       tlzytb
// @match        https://client.plutonodes.net/afk
// @icon         data:image/gif;base64,R0lGODlhAQABAAAAACH5BAEKAAEALAAAAAABAAEAAAICTAEAOw==
// @grant        none
// ==/UserScript==

(function() {
    'use strict';
    // afk check
const discordWebhookUrl = '';

let previousBalance = 0;
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
    const currentBalance = parseFloat(document.getElementById("arciogainedcoins").innerHTML) || 0;
    const currentmultipliers = parseFloat(document.getElementById("totalMultiplier").innerHTML) || 0;

    if (currentBalance !== previousBalance) {
        const message = `=====================\nAFK: ${previousBalance} -> ${currentBalance} XPL\nCurrent Multipliers: ${currentmultipliers}`;
        console.log(message);
        sendDiscordWebhook(message);
        previousBalance = currentBalance;
    }
}

setInterval(check, 15000);
})();