"use strict";

/* 
Инструкция: 
1. Экспортим из гугл-таблиц документ в формате CSV
2. заменяем им файл в папке с названием "TheColors.csv"
3. запускаем этот скрипт — готовый результат в файле 'Refactored.json' 
*/

const fs = require('fs');
//локальный путь до файла
const csvfilepath = 'D:/YandexDisk/!!!!!!!!!!WORK/_Apps/colors/Color Matching/Data/'

const tempData = fs.readFileSync(`${csvfilepath}TheColors.csv`, 'utf8' , (err, data) => {
  if (err) {
    console.error(err)
    return;
  }
  console.log(data)
});



//https://gist.github.com/mjackson/5311256
function rgbToHsv(r, g, b) {
    r /= 255, g /= 255, b /= 255;
  
    var max = Math.max(r, g, b), min = Math.min(r, g, b);
    var h, s, v = max;
  
    var d = max - min;
    s = max == 0 ? 0 : d / max;
  
    if (max == min) {
      h = 0; // achromatic
    } else {
      switch (max) {
        case r: h = (g - b) / d + (g < b ? 6 : 0); break;
        case g: h = (b - r) / d + 2; break;
        case b: h = (r - g) / d + 4; break;
      }
  
      h /= 6;
    }
  
    return [ Math.round(h*360), Math.round(s*100), Math.round(v*100)];
}
//https://stackoverflow.com/questions/5623838/rgb-to-hex-and-hex-to-rgb
/* function hexToRgb(hex) {
  var result = /^#?([a-f\d]{2})([a-f\d]{2})([a-f\d]{2})$/i.exec(hex);
  return result ? {
    r: parseInt(result[1], 16),
    g: parseInt(result[2], 16),
    b: parseInt(result[3], 16)
  } : null;
} */

let arr = tempData.split('\n');
let colors = [];

// matching columns vs array
let hexCodeColumn = 1;
let nameColumn = 3;
let engNameColumn = 2;
let difficulty = 4;
let colorRColumn = 5;
let colorGColumn = 6;
let colorBColumn = 7;



var i = 0;
let twins = 0;
for (var line in arr ) {
  if ( arr[line].split(',')[nameColumn] == 'RuName' 
    || arr[line].split(',')[nameColumn].includes('Крайола')
    ){ continue; };

  colors[i] = {};
  colors[i]['id'] = i;
  colors[i]['hexCode'] = arr[line].split(',')[hexCodeColumn].replace('#','');
  colors[i]['name'] = arr[line].split(',')[nameColumn].trim();
  colors[i]['englishName'] = arr[line].split(',')[engNameColumn]
  colors[i]['colorRGB'] = [+arr[line].split(',')[colorRColumn], +arr[line].split(',')[colorGColumn], +arr[line].split(',')[colorBColumn]];
  colors[i]['colorHSV'] = rgbToHsv(...colors[i]['colorRGB']);
  colors[i]['difficulty'] = arr[line].split(',')[difficulty] ? arr[line].split(',')[difficulty] : "-1" ;
  colors[i]['isGuessed'] = false;
  i++;
}

let colorJson = JSON.stringify(colors, null, "\t")

//Делаем JSON
fs.writeFileSync(`${csvfilepath}Refactored.json`, colorJson, err => {
  if (err) {
    console.error(err)
    return
  }
  //file written successfully
})

//Делаем CSV
let csvForGoogle = ''
for (let key in colors){
  for (let keyvalue in colors[key]){
    csvForGoogle += `${colors[key][keyvalue]},`;
  };
  csvForGoogle += '\n'
};

fs.writeFileSync(`${csvfilepath}Refactored.csv`, csvForGoogle, err => {
  if (err) {
    console.error(err)
    return
  }
  //file written successfully
})

//делаем HTML со всеми цветами
/* let htmlForGoogleStart = `
<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="UTF-8">
<meta http-equiv="X-UA-Compatible" content="IE=edge">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>Document</title>
</head>
<body>
<table id="color-names" class="color-zoom" style="width:100%">`

let htmlForGoogleEnd = `</table> 
</body>
</html>`

let htmlForGoogleInnertext = '' 
for (let hex in colors){
  htmlForGoogleInnertext += `<tr><td bgcolor="${colors[hex]['hexCode']}"></td><td>${(colors[hex]['name'] || 'noname')}</td></tr>`;  
  htmlForGoogleInnertext += '\n'
};
fs.writeFileSync(`${csvfilepath}colors.html`, htmlForGoogleStart + htmlForGoogleInnertext + htmlForGoogleEnd, err => {
  if (err) {
    console.error(err)
    return
  }
  //file written successfully
}) */

console.log('--- start ---');
/* console.log(`we are find ${twins} twins`); */
console.log(`we got json with ${colors.length} objects`);
console.log('---  end  ---');


