#!/usr/bin/env /Users/florian/.nvm/versions/node/v11.9.0/bin/node

const countdowns = {
    'OAK': "2020-02-28 18:00:00",
    'KFJ': "2020-03-07 05:00:00"
}

const getCountDown = (date) =>{
    var countDownDate = new Date(date).getTime();
    var now = new Date().getTime();
    
    var distance = countDownDate - now;
    
    var days = Math.floor(distance  / (1000 * 60 * 60 * 24)).toString();
    var totalHours = Math.floor(distance  / (1000 * 60 * 60)).toString();
    var hours = Math.floor((distance % (1000 * 60 * 60 * 24))  / (1000 * 60 * 60)).toString().padStart(2, '0');
    var minutes = Math.floor((distance % (1000 * 60 * 60)) / (1000 * 60)).toString().padStart(2, '0');
    
    return {days, totalHours, hours, minutes}
}


Object.keys(countdowns).forEach((countdown, i) => {
    let {days, hours, totalHours, minutes} = getCountDown(countdowns[countdown])
    if(days > 4){
        console.log(`${countdown}: ${days}d`);
    }else if(days > 2){
        console.log(`${countdown}: ${days}d ${hours}h`);
    }else{
        console.log(`${countdown}: ${totalHours}h ${minutes}m`);
    }
    if(i == 0){
        console.log('---')
    }
})
