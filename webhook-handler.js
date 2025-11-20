const http = require('http');
const { exec } = require('child_process');

const server = http.createServer((req, res) => {
  if (req.method === 'POST' && req.url === '/api/webhook/github') {
    let body = '';
    
    req.on('data', chunk => body += chunk);
    req.on('end', () => {
      console.log('Webhook received');
      
      // Pull latest code
      exec('cd /root/kurdish-quiz-hub && git pull origin main', (error, stdout, stderr) => {
        if (error) {
          console.error('Git pull error:', error);
          res.writeHead(500);
          res.end('Error');
          return;
        }
        
        console.log('Git pull successful');
        
        // Restart app
        exec('pm2 restart avin-app', (error) => {
          if (error) {
            console.error('PM2 restart error:', error);
            res.writeHead(500);
            res.end('Error');
            return;
          }
          
          console.log('App restarted');
          res.writeHead(200);
          res.end('Success');
        });
      });
    });
  } else {
    res.writeHead(404);
    res.end('Not found');
  }
});

server.listen(9000, () => {
  console.log('Webhook server listening on port 9000');
});
