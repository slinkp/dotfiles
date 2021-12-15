S.log("slinkp slate config loading");

// Configs
S.cfga({
  "defaultToCurrentScreen" : true,
  "secondsBetweenRepeat" : 0.1,
  "checkDefaultsOnLoad" : true,
  "focusCheckWidthMax" : 3000
});

// Nudge operations.

var nudgeX = 30;
var nudgeY = 24;

/*
slate.bind("left:alt,shift", function(win) {
    if (win.isMovable()) {
        win.move({"x": "max({screenOriginX,windowTopLeftX-" + nudgeX + "})",
                  "y": "windowTopLeftY"});
    };
},
true);
*/

/*
slate.bind("right:alt,shift", function(win) {
    if (win.isMovable()) {
        win.move({"x": "min({screenOriginX+screenSizeX-windowSizeX,windowTopLeftX+" + nudgeX + "})",
                  "y": "windowTopLeftY"});
    };
},
true);
*/

/*
slate.bind("up:alt,shift", function(win) {
    if (win.isMovable()) {
        win.move({"y": "max({screenOriginY,windowTopLeftY-" + nudgeY + "})",
                  "x": "windowTopLeftX"});
    };
},
true);
slate.bind("down:alt,shift", function(win) {
    if (win.isMovable()) {
        win.move({"x": "windowTopLeftX",
                  "y": "min({screenOriginY+screenSizeY-windowSizeY,windowTopLeftY+" + nudgeY + "})"});
    };
},
true);
*/

// Find borders of all windows on current screen.

var isSameWindow = function(win1, win2) {
    // Apparently cannot just compare win1 === win2
    return (win1.pid() == win2.pid()
            && win1.screen().id() == win2.screen().id()
            && win1.title() == win2.title()
            && win1.isMain() == win2.isMain()
            // && win1.isMinimizedOrHidden() == win2.isMinimizedOrHidden()
            // && win1.rect().x == win2.rect().x
            // && win1.rect().y == win2.rect().y
            // && win1.rect().width == win2.rect().width
            // && win1.rect().height == win2.rect().height
           );
};

var getAllAppBorders = function(win) {
    S.log("Getting borders");
    var xBorders = {};  // Use a hash as a pseudo-set.
    var yBorders = {};
    // Horrible hack for sometimes things being undefined
    if (S.screen() == undefined) {
        S.log( "Screen undefined in getAllAppBorders??" + S.screen());
    } else if (S.screen().rect() == undefined) {
        S.log( "Rect undefined in getAllAppBorders??", S.screen().rect());
    };
    var screenRect = S.screen().rect();
    var topOfScreen = screenRect.y;
    var leftOfScreen = screenRect.x;
    var bottomOfScreen = topOfScreen + screenRect.height;
    var rightOfScreen = leftOfScreen + screenRect.width;
    var centerScreenX = Math.floor(leftOfScreen + (rightOfScreen - leftOfScreen) / 2);
    var centerScreenY = Math.floor(topOfScreen + (bottomOfScreen - topOfScreen) / 2);

    var winRect = win.rect();
    var centerLeft = Math.max(0, centerScreenX - Math.floor(winRect.width / 2));
    var centerRight = Math.min(rightOfScreen, centerScreenX + Math.floor(winRect.width / 2));

    var centerUp = Math.max(topOfScreen, centerScreenY - Math.floor(winRect.height / 2));
    var centerDown = Math.min(bottomOfScreen, centerScreenY + Math.floor(winRect.height / 2));

    var screenId = S.screen().id();

    S.eachApp(function(app) {
        app.eachWindow(function(otherWin) {
            var appName = app.name();
            if (isSameWindow(win, otherWin)) {
                // S.log("ignoring self", appName);
            } else if (otherWin.screen().id() == screenId) {
                // S.log("got a win for " + appName);
                var rect = otherWin.rect();
                var left = rect.x;
                var right = rect.width + rect.x;
                var top = rect.y;
                var bottom = rect.height + rect.y;
                if (! S.isPointOffScreen(left, topOfScreen)) {
                    // S.log("adding left for", appName, left);
                    xBorders[left] = 1;
                };
                if (! S.isPointOffScreen(right, topOfScreen)) {
                    // S.log("adding right for", appName, right);
                    xBorders[right] = 1;
                };
                if (! S.isPointOffScreen(leftOfScreen, top)) {
                    // S.log("adding top for", appName, top);
                    yBorders[top] = 1;
                };
                if (! S.isPointOffScreen(leftOfScreen, bottom)) {
                    // S.log("adding bottom for", appName, bottom);
                    yBorders[bottom] = 1;
                };
            } else {
                S.log("ignoring win for ", appName, "on other screen");
            };
        });
    });
    xBorders = new Set(Object.keys(xBorders));
    yBorders = new Set(Object.keys(yBorders));

    // Screen edges.
    xBorders.add(leftOfScreen);
    xBorders.add(rightOfScreen);
    yBorders.add(topOfScreen);
    yBorders.add(rightOfScreen);

    // Add center to borders.
    xBorders.add(centerScreenX);
    xBorders.add(centerLeft);
    xBorders.add(centerRight);

    yBorders.add(centerScreenY);
    yBorders.add(centerUp);
    yBorders.add(centerDown);

    xBorders = Array.from(xBorders);
    yBorders = Array.from(yBorders);
    xBorders.sort(function(a, b) { return a - b});
    yBorders.sort(function(a, b) { return a - b});

    S.log("DONE with borders.");
    // S.log("X borders", xBorders);
    // S.log("Y borders", yBorders);
    return [xBorders, yBorders];
};

// Pseudo-tiling: Move to next edge.
var moveToNextWindowEdge = function(win, direction) {
    if (! win.isMovable()) {
        S.log("Cannot move", win.title());
        return;
    };
    S.log("MOVING in direction " + direction);
    var rect = win.rect();
    var top = rect.y;
    var left = rect.x;
    var right = rect.width + left;
    var bottom = rect.height + top;
    // Find edges of interest.
    var allBorders = getAllAppBorders(win);
    var xBorders = allBorders[0];
    var yBorders = allBorders[1];
    // S.log("Starting from T", top, "B", bottom, "R", right, "L", left);
    // S.log("vert borders are ", xBorders);
    // S.log("horiz borders are ", yBorders);

    var screenRect = S.screen().rect();
    var topOfScreen = screenRect.y;
    var leftOfScreen = screenRect.x;
    var bottomOfScreen = topOfScreen + screenRect.height;
    var rightOfScreen = leftOfScreen + screenRect.width;

    var getNewCoords = null;
    var borders = null;

    // TODO: check that we're actually hitting an edge,
    // not just aligned with it ... eg. if we're moving up,
    // we don't care about windows that we're not actually bumping
    // into.  Hmm.  Basic bounding-box collision detection?
    // Or not. Snapping to all edges is at most minor inconvenience,
    // and sometimes useful.
    var distances = [];
    var winEdge1, winEdge2, cmp, limit;
    var ascending = function(a, b) { return a - b};
    var descending = function(a, b) { return b - a};
    var distancesOrder;
    if (direction === 'right') {
        winEdge1 = left;
        winEdge2 = right;
        borders = xBorders;
        cmp = function(a, b) {
            return a > b && (a - b + right <= rightOfScreen);
        };
        distancesOrder = ascending;
    } else if (direction === 'left') {
        winEdge1 = left;
        winEdge2 = right;
        borders = xBorders.reverse();
        cmp = function(a, b) {
            return a < b && (a - b + left >= leftOfScreen);
        };
        distancesOrder = descending;
    } else if (direction === 'down') {
        winEdge1 = top;
        winEdge2 = bottom;
        borders = yBorders;
        cmp = function(a, b) {
            return a > b && (a - b + bottom <= bottomOfScreen);
        };
        distancesOrder = ascending;
    } else if (direction === 'up') {
        winEdge1 = top;
        winEdge2 = bottom;
        borders = yBorders.reverse();
        cmp = function(a, b) {
            return a < b && (a - b + top >= topOfScreen);
        };
        distancesOrder = descending;
    };
    S.log("borders", borders);
    for (var i=0; i < borders.length; i++) {
        // S.log("Testing " + borders[i]);

        if (cmp(borders[i], winEdge1)) {
            // S.log("Yes, compared to edge 1:", winEdge1);
            distances.push(borders[i] - winEdge1);
        };
        if (cmp(borders[i], winEdge2)) {
            // S.log("Yes, compared to edge 2:", winEdge2);
            distances.push(borders[i] - winEdge2);
        };
    };
    distances.sort(distancesOrder);
    // S.log("distances", distances);
    if (distances.length === 0) {
        S.log("nowhere to move");
        return;
    };
    S.log("Moving by " + distances[0]);
    if (direction === "left" || direction === "right") {
        win.move({x: left + distances[0], y: top});
    } else {
        win.move({x: left, y: top + distances[0]});
    }
    return;
};

//slate.bind("up:shift,alt,cmd", getAllAppBorders, false);
slate.bind("right:ctrl,shift,cmd", function(win) {
    moveToNextWindowEdge(win, "right");
}, true);

slate.bind("left:ctrl,shift,cmd", function(win) {
    moveToNextWindowEdge(win, "left");
}, true);

slate.bind("up:ctrl,shift,cmd", function(win) {
    moveToNextWindowEdge(win, "up");
}, true);

slate.bind("down:ctrl,shift,cmd", function(win) {
    moveToNextWindowEdge(win, "down");
}, true);

S.log("slinkp slate config load finished!");
