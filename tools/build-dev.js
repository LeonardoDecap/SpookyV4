// Adapted from 7GrandDadPGN/VapeBundler for the SpookyV4 dev branch.
// Output stays in this repository so the DEV loader never needs VapeCompiled.
const fs = require('node:fs');
const path = require('node:path');
const processGame = require('./bundler/helpers/processGame.js');
const processUI = require('./bundler/helpers/processUI.js');
const {VARS, makePath} = require('./bundler/helpers/vars.js');

const root = path.resolve(__dirname, '..');
const source = path.join(root, 'src');
const output = path.join(root, 'dev-build');
VARS.IS_DEV = true;
VARS.DEST_PATH = output;

for (const folder of ['', 'assets', 'libraries', 'games', 'guis']) {
	makePath(path.join(output, folder));
}

for (const file of ['loader.lua', 'main.lua']) {
	fs.copyFileSync(path.join(source, file), path.join(output, file));
}
for (const file of fs.readdirSync(path.join(source, 'libraries'))) {
	fs.copyFileSync(path.join(source, 'libraries', file), path.join(output, 'libraries', file));
}
for (const gui of fs.readdirSync(path.join(source, 'guis'))) {
	processUI(path.join(source, 'guis', gui), gui);
}
for (const game of fs.readdirSync(path.join(source, 'games'))) {
	if (game.includes('-')) {
		processGame(path.join(source, 'games', game), game);
	} else {
		const gamePath = path.join(source, 'games', game);
		for (const extra of fs.readdirSync(gamePath)) {
			processGame(path.join(gamePath, extra), extra);
		}
	}
}
console.log('SpookyV4 dev-build complete');
