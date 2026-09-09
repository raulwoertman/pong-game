<!DOCTYPE html>
<html lang="nl">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Pong Spel</title>
    <style>
        body {
            background-color: #111;
            color: #fff;
            font-family: sans-serif;
            display: flex;
            flex-direction: column;
            align-items: center;
            justify-content: center;
            height: 100vh;
            margin: 0;
        }
        canvas {
            border: 4px solid #fff;
            background-color: #000;
        }
    </style>
</head>
<body>

    <h1>Pong</h1>
    <canvas id="pongCanvas" width="800" height="400"></canvas>

    <script>
        const canvas = document.getElementById('pongCanvas');
        const ctx = canvas.getContext('2d');

        // Spelobjecten
        const paddleWidth = 10, paddleHeight = 80;
        const player = { x: 10, y: canvas.height / 2 - paddleHeight / 2, score: 0 };
        const ai = { x: canvas.width - 20, y: canvas.height / 2 - paddleHeight / 2, score: 0 };
        const ball = { x: canvas.width / 2, y: canvas.height / 2, radius: 8, speedX: 5, speedY: 5 };

        // Besturing speler (muis)
        canvas.addEventListener('mousemove', (e) => {
            const rect = canvas.getBoundingClientRect();
            player.y = e.clientY - rect.top - paddleHeight / 2;
        });

        // Tekenfuncties
        function drawRect(x, y, w, h, color) {
            ctx.fillStyle = color;
            ctx.fillRect(x, y, w, h);
        }

        function drawCircle(x, y, r, color) {
            ctx.fillStyle = color;
            ctx.beginPath();
            ctx.arc(x, y, r, 0, Math.PI * 2);
            ctx.closePath();
            ctx.fill();
        }

        function drawText(text, x, y) {
            ctx.fillStyle = '#fff';
            ctx.font = '32px sans-serif';
            ctx.fillText(text, x, y);
        }

        function resetBall() {
            ball.x = canvas.width / 2;
            ball.y = canvas.height / 2;
            ball.speedX = -ball.speedX;
            ball.speedY = 4 * (Math.random() > 0.5 ? 1 : -1);
        }

        // Spel-update
        function update() {
            // Bal beweging
            ball.x += ball.speedX;
            ball.y += ball.speedY;

            // Boven- en onderkant botsingen
            if (ball.y - ball.radius < 0 || ball.y + ball.radius > canvas.height) {
                ball.speedY = -ball.speedY;
            }

            // Eenvoudige AI voor de tegenstander
            const aiTarget = ball.y - paddleHeight / 2;
            ai.y += (aiTarget - ai.y) * 0.1;

            // Botsing met speler
            if (ball.x - ball.radius < player.x + paddleWidth &&
                ball.y > player.y && ball.y < player.y + paddleHeight) {
                ball.speedX = -ball.speedX;
            }

            // Botsing met AI
            if (ball.x + ball.radius > ai.x &&
                ball.y > ai.y && ball.y < ai.y + paddleHeight) {
                ball.speedX = -ball.speedX;
            }

            // Scoren
            if (ball.x < 0) {
                ai.score++;
                resetBall();
            } else if (ball.x > canvas.width) {
                player.score++;
                resetBall();
            }
        }

        // Renderen op het scherm
        function render() {
            drawRect(0, 0, canvas.width, canvas.height, '#000'); // Achtergrond
            drawRect(player.x, player.y, paddleWidth, paddleHeight, '#fff'); // Speler
            drawRect(ai.x, ai.y, paddleWidth, paddleHeight, '#fff'); // AI
            drawCircle(ball.x, ball.y, ball.radius, '#fff'); // Bal
            drawText(player.score, canvas.width / 4, 50); // Score speler
            drawText(ai.score, (3 * canvas.width) / 4, 50); // Score AI
        }

        // Game loop
        function gameLoop() {
            update();
            render();
            requestAnimationFrame(gameLoop);
        }

        gameLoop();
    </script>
</body>
</html>
