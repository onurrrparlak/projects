async function checkM3U8(url) {
    try {
        const response = await fetch(url);
        if (response.ok) {
            const m3u8Content = await response.text();
            // Perform checks or analysis on the m3u8Content here

            // For example, check if the file contains valid segments or specific information
            if (m3u8Content.includes('#EXT-X-TARGETDURATION')) {
                console.log('Valid M3U8 file');
            } else {
                console.log('Invalid M3U8 file');
            }
        } else {
            console.error('Error fetching M3U8 file:', response.status);
        }
    } catch (error) {
        console.error('Error fetching M3U8 file:', error);
    }
}

// Usage
const m3u8URL = 'https://example.com/path/to/video.m3u8';
checkM3U8(m3u8URL);
