// ==UserScript==
// @name         stake check
// @namespace
// @version      2024-10-20
// @description  try to take over the world!
// @author       tlzytb
// @match        https://client.plutonodes.net/staking
// @icon         data:image/gif;base64,R0lGODlhAQABAAAAACH5BAEKAAEALAAAAAABAAEAAAICTAEAOw==
// @grant        none
// ==/UserScript==

(function() {
    'use strict';

    //stake check

const discordWebhookUrl = ''; // discord webhook again
let lastEarnings = null;

async function check() {
    try {
        const currentEarnings = parseFloat(document.getElementById("total-earnings").innerHTML) || 0;

        if (lastEarnings !== currentEarnings) {
            lastEarnings = currentEarnings;
            sendD(`Stack Earnings updated: ${currentEarnings} PlutoCoins/XPL`);
        }
    } catch (error) {
        console.error('error:', error);
    }
}

function sendD(content) {
    fetch(discordWebhookUrl, {
        method: 'POST',
        headers: {
            'Content-Type': 'application/json',
        },
        body: JSON.stringify({ content }),
    })
    .then(() => console.log('Webhook sent:', content))
    .catch((error) => console.error('error:', error));
}
setInterval(check, 5000);
})();