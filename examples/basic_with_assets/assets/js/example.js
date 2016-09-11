'use strict';

let count = 0;
const counterButton = document.getElementById('counterButton');
const counter = document.getElementById('counter');
counterBtn.addEventListener('click', () => {
	count += 1;
	counter.innerHTML = count;
});
