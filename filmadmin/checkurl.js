function checkStream(url) {
    fetch(url)
        .then(response => {
            if (response.ok) {
                console.log('Stream is reachable.');
            } else {
                console.error('Error: Stream is not reachable.');
            }
        })
        .catch(error => {
            console.error('Error:', error);
        });
}

// Example usage:
const testURL = 'https://yot.gnicirp.com/_v10/514604b7be289fdc3aa19b99476e24af437add698611a0178e7e49c139c8e7ee56ceeaae24d42739ccacd4f4066dcf7d2be640015e3cbd7113960b658da5a6d63874508052d1a7961104c946bd463bfbc26edf5f7e7bb234117100dd4a45eebbb180eece7226a239db68af949ddabc2f4646d3099a84ed4eb860ca39ff7fbcc25af83696c06bf29c9ac27ab91d521030/1080/index.m3u8';
checkStream(testURL);
