exports.generateTemplate = async (type, data) => {
  let accountTemplate = `<html>
  <head>
<link rel="preconnect" href="
https://fonts.googleapis.com">
<link rel="preconnect" href="
https://fonts.gstatic.com"
crossorigin>
<link href="
https://fonts.googleapis.com/css2?family=Ubuntu:ital,wght@0,300;0,400;0,500;0,700;1,300;1,400;1,500;1,700&display=swap"
rel="stylesheet">
</head>
    <body style="background-color:#00000; padding:25px">
    <div style="background-color:#f3f1ef; margin: 2.4vh auto; color:black; border-radius:25px; text-align:center; min-width: 20vw; max-width: 68vw;">
     
          <div style="padding:25px; font-family: Ubuntu, sans-serif;">
    <div>
    <img src="https://itamt.riota.in/assets/assets/images/asset_logo.png" alt="Logo" width="70" height="50">
    <!-- img -->
    </div>
    <h1>Welcome To ITAM!</h1>
    <div>
    <p style="line-height: 21px;"
    >Hi ${data.userName}! ${data.type}. Login to your account with the credentials listed below.</p>
<div style="display:flex;justify-content:center">
    <div  style="text-align:left">
    <div style="margin-bottom:10px">
    <b>Email : </b><span>${data.userEmailId}</span></div>
    <div>
    <b>Password : </b><span> ${data.originalPassowrd}</span></div>
    </div>
    </div>
    <a href="
https://itamt.riota.in/"
target="./blank" style="text-decoration: none; color:white">
<button style="margin-top:25px; padding:12px 32px; border-radius:50px; background:#2b8be6; color:white; border:0px; cursor:pointer">Login to your Account</button></a>
    </div>
    <p style="font-size:10px; color:grey;">© RIOTA Private Limited 2024</p>
    </div>
    </div>
    </body>
    </html>`;

  let supportTemplate = `<html>
  <head>
<link rel="preconnect" href="
https://fonts.googleapis.com">
<link rel="preconnect" href="
https://fonts.gstatic.com"
crossorigin>
<link href="
https://fonts.googleapis.com/css2?family=Ubuntu:ital,wght@0,300;0,400;0,500;0,700;1,300;1,400;1,500;1,700&display=swap"
rel="stylesheet">
</head>
    <body style="background-color:#00000; padding:25px">
    <div style="background-color:#f3f1ef; margin: 2.4vh auto; color:black; border-radius:25px; text-align:center; min-width: 20vw; max-width: 68vw;">
     
          <div style="padding:25px; font-family: Ubuntu, sans-serif;">
    <div>
    <img src="https://itamt.riota.in/assets/assets/images/asset_logo.png" alt="Logo" width="70" height="50">
    <!-- img -->
    </div>
    <h1>${data.heading}</h1>
    <div>
    <p style="line-height: 21px;"
    >${data.type}</p>
    <div style="display:flex;justify-content:center">
    <div  style="text-align:center; font-size:15px;">
    <div style="margin-bottom:10px">
    <b>Description : </b><span>${data.descriptions}</span></div>
    </div>
    </div>
<div style="display:flex;justify-content:center">
    <p style="font-size:10px; color:grey;">© RIOTA Private Limited 2024</p>
    </div>
    </div>
    </body>
    </html>`;

  let helpTemplate = `<html>
  <head>
<link rel="preconnect" href="
https://fonts.googleapis.com">
<link rel="preconnect" href="
https://fonts.gstatic.com"
crossorigin>
<link href="
https://fonts.googleapis.com/css2?family=Ubuntu:ital,wght@0,300;0,400;0,500;0,700;1,300;1,400;1,500;1,700&display=swap"
rel="stylesheet">
</head>
    <body style="background-color:#00000; padding:25px">
    <div style="background-color:#f3f1ef; margin: 2.4vh auto; color:black; border-radius:25px; text-align:center; min-width: 20vw; max-width: 68vw;">
     
          <div style="padding:25px; font-family: Ubuntu, sans-serif;">
    <div>
    <img src="https://itamt.riota.in/assets/assets/images/asset_logo.png" alt="Logo" width="70" height="50">
    <!-- img -->
    </div>
    <h1>${data.heading}</h1>
    <div>
    <div style="display:flex;justify-content:center">
    <div  style="text-align:center; font-size:15px;">
    
    <b>Description : </b><span>${data.descriptions}</span>
    </div>
    </div>
    <div style="margin-bottom:10px">
    </div>
<div style="display:flex;justify-content:center">
    <p style="font-size:10px; color:grey;">© RIOTA Private Limited 2024</p>
    </div>
    </div>
    </body>
    </html>`;

  let ticketTemplate = `<html>
  <head>
<link rel="preconnect" href="
https://fonts.googleapis.com">
<link rel="preconnect" href="
https://fonts.gstatic.com"
crossorigin>
<link href="
https://fonts.googleapis.com/css2?family=Ubuntu:ital,wght@0,300;0,400;0,500;0,700;1,300;1,400;1,500;1,700&display=swap"
rel="stylesheet">
</head>
    <body style="background-color:#00000; padding:25px">
    <div style="background-color:#f3f1ef; margin: 2.4vh auto; color:black; border-radius:25px; text-align:center; min-width: 20vw; max-width: 68vw;">
     
          <div style="padding:25px; font-family: Ubuntu, sans-serif;">
    <div>
    <img src="https://itamt.riota.in/assets/assets/images/asset_logo.png" alt="Logo" width="70" height="50">
    <!-- img -->
    </div>
    <h1>${data.heading}</h1>
    <div>
    <p style="line-height: 21px;"
    >${data.type}</p>
    <div style="display:flex;justify-content:center">
<div style="display:flex;justify-content:center">
    <p style="font-size:10px; color:grey;">© RIOTA Private Limited 2024</p>
    </div>
    </div>
    </body>
    </html>`;

  let rsspTemplate = `<html>
  <head>
<link rel="preconnect" href="
https://fonts.googleapis.com">
<link rel="preconnect" href="
https://fonts.gstatic.com"
crossorigin>
<link href="
https://fonts.googleapis.com/css2?family=Ubuntu:ital,wght@0,300;0,400;0,500;0,700;1,300;1,400;1,500;1,700&display=swap"
rel="stylesheet">
</head>
    <body style="background-color:#00000; padding:25px">
    <div style="background-color:#f3f1ef; margin: 2.4vh auto; color:black; border-radius:25px; text-align:center; min-width: 20vw; max-width: 68vw;">
     
          <div style="padding:25px; font-family: Ubuntu, sans-serif;">
    <div>
    <img src="https://rssp.riota.in/assets/assets/images/riota_logo.png" alt="Logo" width="70" height="50">
    <!-- img -->
    </div>
    <h1>Welcome To RIOTA!</h1>
    <div>
    <p style="line-height: 21px;"
    >Hi ${data.userName}! ${data.type}. Login to your account with the credentials listed below.</p>
<div style="display:flex;justify-content:center">
    <div  style="text-align:left">
    <div style="margin-bottom:10px">
    <b>Email : </b><span>${data.userEmailId}</span></div>
    <div>
    <b>Password : </b><span> ${data.originalPassowrd}</span></div>
    </div>
    </div>
    <a href="
https://my.riota.in/"
target="./blank" style="text-decoration: none; color:white">
<button style="margin-top:25px; padding:12px 32px; border-radius:50px; background:#2b8be6; color:white; border:0px; cursor:pointer">Login to your Account</button></a>
    </div>
    <p style="font-size:10px; color:grey;">© RIOTA Private Limited 2024</p>
    </div>
    </div>
    </body>
    </html>`;

  if (type == "support") {
    return supportTemplate;
  } else if (type == "account") {
    return accountTemplate;
  } else if (type == "help") {
    return helpTemplate;
  } else if (type == "ticket") {
    return ticketTemplate;
  } else if (type == "rssp") {
    return rsspTemplate;
  }
};
