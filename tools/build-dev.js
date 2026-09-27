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
// Keep generated Lua identical across Windows and Linux checkouts and avoid
// indentation-only lines introduced by the upstream bundler helpers.
function normalizeLua(folder) {
	for (const name of fs.readdirSync(folder)) {
		const file = path.join(folder, name);
		if (fs.statSync(file).isDirectory()) {
			normalizeLua(file);
		} else if (name.endsWith('.lua')) {
			const data = fs.readFileSync(file, 'utf8').replace(/\r\n/g, '\n').replace(/[ \t]+$/gm, '');
			fs.writeFileSync(file, data);
		}
	}
}
normalizeLua(output);
console.log('SpookyV4 dev-build complete');
