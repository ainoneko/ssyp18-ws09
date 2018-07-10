
// A cross-browser requestAnimationFrame
// See https://hacks.mozilla.org/2011/08/animating-with-javascript-from-setinterval-to-requestanimationframe/
var requestAnimFrame = (function(){
    return window.requestAnimationFrame       ||
        window.webkitRequestAnimationFrame ||
        window.mozRequestAnimationFrame    ||
        window.oRequestAnimationFrame      ||
        window.msRequestAnimationFrame     ||
        function(callback){
            window.setTimeout(callback, 1000 / 60);
        };
})();

FOOD_WIDTH = 26 // 80; // ??
FOOD_HEIGHT = 50 // 39; // ??
FOOD_SIZE = [FOOD_WIDTH, FOOD_HEIGHT];
FOOD_SPRITE_POS = [280, 20]//[200, 0];
FOOD_FRAMES = [0]

ENENY_WIDTH = 40// 80; // ??
ENENY_HEIGHT = 30  // 39; // ??
ENENY_SIZE = [ENENY_WIDTH, ENENY_HEIGHT];
ENENY_SPRITE_POS = [212, 45]// [0, 78];
ENEMY_FRAMES = [0]

PLAYER_WIDTH =  50 // 39;
PLAYER_HEIGHT = 80 // 39;
PLAYER_SIZE = [PLAYER_WIDTH, PLAYER_HEIGHT];
PLAYER_SPRITE_POS = [350, 10]// [0, 0];
PLAYER_FRAMES = [0, 1]

SPRITE_FILE = 'img/sprites.png';
// FOOD_SPRITE_FILE = 'img/sprites.png';
FOOD_SPRITE_FILE = SPRITE_FILE;
// PLAYER_SPRITE_FILE = 'img/chilla.png';
PLAYER_SPRITE_FILE = SPRITE_FILE;
// BG_IMAGE = 'img/terrain.png';
BG_IMAGE = 'img/try_bg.png';

SCORE_FOR_EAT_FOOD = 100;
SCORE_FOR_SHOOT_ENEMY = 100;
SCORE_FOR_SHOOT_FOOD = 10;
SCORE_FOR_MISS_FOOD = -1;

ENEMY_RATE = 0.2;
FOOD_RATE = 0.5;

// Create the canvas
var canvas = document.createElement("canvas");
var ctx = canvas.getContext("2d");
// canvas.width = 512;
// canvas.height = 480;
canvas.width = 683;
canvas.height = 512;

document.body.appendChild(canvas);

// The main game loop
var lastTime;
function main() {
    var now = Date.now();
    var dt = (now - lastTime) / 1000.0;

    update(dt);
    render();

    lastTime = now;
    requestAnimFrame(main);
};

function init() {
    terrainPattern = ctx.createPattern(resources.get(BG_IMAGE), 'repeat');
    //terrainPattern = ctx.createPattern(resources.get('img/Background_night.png'), 'repeat');
    
    document.getElementById('play-again').addEventListener('click', function() {
        reset();
    });

    document.getElementById('resume-button').addEventListener('click', function() {
        resume_game();
    });
    
    document.getElementById('resume').style.display = 'none';
    reset();
    lastTime = Date.now();
    main();
}

resources.load([
    SPRITE_FILE,
    FOOD_SPRITE_FILE,
    PLAYER_SPRITE_FILE,
    BG_IMAGE
    // 'img/sprites.png',
    // 'img/terrain.png'
]);
resources.onReady(init);

// Game state
var player = {
    pos: [0, 0],
    // sprite: new Sprite('img/sprites.png', [0, 0], [39, 39], 16, [0, 1])
    sprite: new Sprite(PLAYER_SPRITE_FILE, PLAYER_SPRITE_POS, PLAYER_SIZE, 16, PLAYER_FRAMES)
};

var bullets = [];
var enemies = [];
var explosions = [];

var food = [];

var lastFire = Date.now();
var gameTime = 0;
var isGameOver;
var isPaused = false;
var terrainPattern;

var score = 0;
var scoreEl = document.getElementById('score');

// Speed in pixels per second
var playerSpeed = 200;
var bulletSpeed = 500;
var enemySpeed = 100;

var foodSpeed = 100;



function pause_game(){
    isPaused = true;
    // show 'resume' button
    document.getElementById('resume').style.display = 'block';
    // document.getElementById('resume-overlay').style.display = 'block';
    


}

function resume_game(){
    isPaused = false;
     // hide 'resume' button

    document.getElementById('resume').style.display = 'none';
    //  document.getElementById('resume-overlay').style.display = 'none';
}


// Update game objects
function update(dt) {
    if (isPaused) return;

    gameTime += dt;

    handleInput(dt);
    updateEntities(dt);

    // It gets harder over time by adding enemies using this
    // equation: 1-.993^gameTime
    // if(Math.random() < 1 - Math.pow(.993, gameTime)) {
    //     enemies.push({
    //         pos: [canvas.width,
    //               Math.random() * (canvas.height - 39)],
    //         sprite: new Sprite('img/sprites.png', [0, 78], [80, 39],
    //                            6, [0, 1, 2, 3, 2, 1])
    //     });
    // }

    // add an enemy
    if(Math.random() < ENEMY_RATE * (1 - Math.pow(.993, gameTime))) {
        enemies.push({
            pos: [Math.random() * (canvas.width - ENENY_WIDTH),
                  10],
            sprite: new Sprite(SPRITE_FILE, ENENY_SPRITE_POS, ENENY_SIZE,
            //  [FOOD_WIDTH, FOOD_HEIGHT],
                               6, ENEMY_FRAMES)
        });
    }

    // add food
    if(Math.random() < FOOD_RATE * (1 - Math.pow(.993, gameTime))) {
        food.push({
            pos: [Math.random() * (canvas.width - FOOD_WIDTH),
                  10],
            sprite: new Sprite(FOOD_SPRITE_FILE, FOOD_SPRITE_POS, FOOD_SIZE,
            //  [FOOD_WIDTH, FOOD_HEIGHT],
                               6, FOOD_FRAMES)
        });
    }

    checkCollisions();

    scoreEl.innerHTML = score;
};

function handleInput(dt) {
    if(input.isDown('DOWN') || input.isDown('s')) {
        player.pos[1] += playerSpeed * dt;
    }

    if(input.isDown('UP') || input.isDown('w')) {
        player.pos[1] -= playerSpeed * dt;
    }

    if(input.isDown('LEFT') || input.isDown('a')) {
        player.pos[0] -= playerSpeed * dt;
    }

    if(input.isDown('RIGHT') || input.isDown('d')) {
        player.pos[0] += playerSpeed * dt;
    }

    if(input.isDown('P') || input.isDown('G') || input.isDown('H')) { // 'G' -- "П"
        pause_game();
    }
    // if(input.isDown('R')) { 
    //     resume_game();
    // }
    if(input.isDown('SPACE') &&
       !isGameOver &&
       !isPaused &&
       Date.now() - lastFire > 100) {
        var x = player.pos[0] + player.sprite.size[0] / 2;
        var y = player.pos[1] + player.sprite.size[1] / 2;

        bullets.push({ pos: [x, y],
                       dir: 'forward',
                       sprite: new Sprite('img/sprites.png', [0, 39], [18, 8]) });
        // XXX TODO NEW sprite ?              
        bullets.push({ pos: [x, y],
                       dir: 'backward',
                       sprite: new Sprite('img/sprites.png', [0, 39], [18, 8]) });
        bullets.push({ pos: [x, y],
                       dir: 'up',
                       sprite: new Sprite('img/sprites.png', [0, 50], [9, 5]) });
        bullets.push({ pos: [x, y],
                       dir: 'down',
                       sprite: new Sprite('img/sprites.png', [0, 60], [9, 5]) });

        lastFire = Date.now();
    }
}

function enemy_missed(pos){
    console.log('Enemy missed', pos);
}

function updateEntities(dt) {

    //  if (isPaused) return; -- see update(dt) calling this
    // Update the player sprite animation
    player.sprite.update(dt);

    // Update all the bullets
    for(var i=0; i<bullets.length; i++) {
        var bullet = bullets[i];

        switch(bullet.dir) {
        case 'up': bullet.pos[1] -= bulletSpeed * dt; break;
        case 'down': bullet.pos[1] += bulletSpeed * dt; break;
        case 'backward': bullet.pos[0] -= bulletSpeed * dt; break;
        default:
            bullet.pos[0] += bulletSpeed * dt;
        }

        // Remove the bullet if it goes offscreen
        if(bullet.pos[1] < 0 || bullet.pos[1] > canvas.height ||
           bullet.pos[0] > canvas.width) {
            bullets.splice(i, 1);
            i--;
        }
    }

    // Update all the enemies
    for(var i=0; i<enemies.length; i++) {
        // enemies[i].pos[0] -= enemySpeed * dt;  // move left
        enemies[i].pos[1] += enemySpeed * dt;  // move down
        enemies[i].sprite.update(dt);

        // ---
        // Remove if offscreen
        // Check if went left
        // if(enemies[i].pos[0] + enemies[i].sprite.size[0] < 0) {
        //     enemies.splice(i, 1);
        //     i--;
        // }

        // Check if went down 
        // missed it
        if(enemies[i].pos[1] > canvas.height) {

                
            enemy_missed(enemies[i].pos);
            var p_pos = enemies.splice(i, 1);
            console.log('pos=', p_pos);
            i--;
                

        }

    }

        // Update all food
        for(var i=0; i<food.length; i++) {
            food[i].pos[1] += foodSpeed * dt;  // move down
            food[i].sprite.update(dt);
 
            // Check if went down 
            // missed it
            if(food[i].pos[1] > canvas.height) {
    
                    // XXX TODO
                // food_missed(food[i].pos);
                var p_pos = food.splice(i, 1);
                score += SCORE_FOR_MISS_FOOD;
                i--;
                    
    
            }
    
        }

    // Update all the explosions
    for(var i=0; i<explosions.length; i++) {
        explosions[i].sprite.update(dt);

        // Remove if animation is done
        if(explosions[i].sprite.done) {
            explosions.splice(i, 1);
            i--;
        }
    }
}

// Collisions

function collides(x, y, r, b, x2, y2, r2, b2) {
    return !(r <= x2 || x > r2 ||
             b <= y2 || y > b2);
}

function boxCollides(pos, size, pos2, size2) {
    return collides(pos[0], pos[1],
                    pos[0] + size[0], pos[1] + size[1],
                    pos2[0], pos2[1],
                    pos2[0] + size2[0], pos2[1] + size2[1]);
}


function food_eaten(pos){

    console.log('Food eaten');
    score += SCORE_FOR_EAT_FOOD;
}

function checkCollisions() {
    checkPlayerBounds();
    
    // Run collision detection for all enemies and bullets
    for(var i=0; i<enemies.length; i++) {
        var pos = enemies[i].pos;
        var size = enemies[i].sprite.size;

        for(var j=0; j<bullets.length; j++) {
            var pos2 = bullets[j].pos;
            var size2 = bullets[j].sprite.size;

            if(boxCollides(pos, size, pos2, size2)) {
                // Remove the enemy
                enemies.splice(i, 1);
                i--;

                // Add score for shooting enemy
                score += SCORE_FOR_SHOOT_ENEMY;

                // Add an explosion
                explosions.push({
                    pos: pos,
                    sprite: new Sprite('img/sprites.png',
                                       [0, 117],
                                       [39, 39],
                                       16,
                                       [0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12],
                                       null,
                                       true)
                });

                // Remove the bullet and stop this iteration
                bullets.splice(j, 1);
                break;
            }
        }

        if(boxCollides(pos, size, player.pos, player.sprite.size)) {
            gameOver();
        }
    }

        // Run collision detection for all food and bullets
        for(var i=0; i<food.length; i++) {
            var pos = food[i].pos;
            var size = food[i].sprite.size;
    
            for(var j=0; j<bullets.length; j++) {
                var pos2 = bullets[j].pos;
                var size2 = bullets[j].sprite.size;
    
                if(boxCollides(pos, size, pos2, size2)) {
                    // Remove the food
                    food.splice(i, 1);
                    i--;
    
                    // Add score
                    score += SCORE_FOR_SHOOT_FOOD;
    
                    // Add an explosion
                    explosions.push({
                        pos: pos,
                        sprite: new Sprite(SPRITE_FILE,
                                           [0, 117],
                                           [39, 39],
                                           16,
                                           [0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12],
                                           null,
                                           true)
                    });
    
                    // Remove the bullet and stop this iteration
                    bullets.splice(j, 1);
                    break;
                }
            }
    
            if(boxCollides(pos, size, player.pos, player.sprite.size)) {
                // gameOver();
                food_eaten(pos);
                // Remove the food
                food.splice(i, 1);
                i--;
            }
        }
}

function checkPlayerBounds() {
    // Check bounds
    if(player.pos[0] < 0) {
        player.pos[0] = 0;
    }
    else if(player.pos[0] > canvas.width - player.sprite.size[0]) {
        player.pos[0] = canvas.width - player.sprite.size[0];
    }

    if(player.pos[1] < 0) {
        player.pos[1] = 0;
    }
    else if(player.pos[1] > canvas.height - player.sprite.size[1]) {
        player.pos[1] = canvas.height - player.sprite.size[1];
    }
}

// Draw everything
function render() {
    ctx.fillStyle = terrainPattern;
    ctx.fillRect(0, 0, canvas.width, canvas.height);

    // Render the player if the game isn't over
    if(!isGameOver) {
        renderEntity(player);
    }

    renderEntities(bullets);
    renderEntities(enemies);
    renderEntities(explosions);

    renderEntities(food);
};

function renderEntities(list) {
    for(var i=0; i<list.length; i++) {
        renderEntity(list[i]);
    }    
}

function renderEntity(entity) {
    ctx.save();
    ctx.translate(entity.pos[0], entity.pos[1]);
    entity.sprite.render(ctx);
    ctx.restore();
}

// Game over
function gameOver() {
    document.getElementById('game-over').style.display = 'block';
    document.getElementById('game-over-overlay').style.display = 'block';
    isGameOver = true;
}

// Reset game to original state
function reset() {
    document.getElementById('game-over').style.display = 'none';
    document.getElementById('game-over-overlay').style.display = 'none';
    isGameOver = false;
    gameTime = 0;
    score = 0;

    enemies = [];
    bullets = [];

//    player.pos = [50, canvas.height / 2];

    player.pos = [canvas.width / 2, canvas.height / 2];
};
