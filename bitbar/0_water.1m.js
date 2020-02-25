#!/usr/bin/env /Users/florian/.nvm/versions/node/v11.9.0/bin/node

const {execSync, exec} = require('child_process');

const getLastWater = () =>{
    return parseInt(execSync(`tail -1 ~/.dotfiles/bitbar/water/log`))
}


let lastWater = getLastWater();
let now = new Date();

let icon = `💧`;

if(now.getDay() == 5 && 16 <= now.getHours() && now.getHours() < 20 ){
    icon = `:beer:`;
}


let distance = now.getTime() - lastWater;
let minutesPerDrop = 10;

if(distance > 0){
    let drops = Math.floor(distance / (1000 * 60 * minutesPerDrop));

    drops = drops > 6 ? 6 : drops;

    console.log(Array(drops).fill(icon).join(''));
    console.log('---');
    console.log('OKAY!|bash=~/.dotfiles/bitbar/water/log.sh terminal=false refresh=true');
}
