const default_map = await Deno.readTextFile('./maps/default.map')
const intro_story_map = await Deno.readTextFile('./maps/intro-story.map')

function worldspawn_section(map) {
	let out = ""
	let counter = 0;
	for (const character of map) {
		if (character == '{') {
			counter += 1;
			if (counter == 1) {
				continue;
			}
		} else if (character == '}') {
			counter -= 1;
		}
		if (counter > 0) {
			out += character;
		}
		if (out.length > 0 && counter <= 0) {
			break
		}
	}
	return out
}

function entities_section(map) {
	let out = ""
	let counter = 0;
	let past_worldspawn = false;
	for (const character of map) {
		if (past_worldspawn) {
			out += character;
		}
		if (character == '{') {
			counter += 1;
		} else if (character == '}') {
			counter -= 1;
			if (counter == 0) {
				past_worldspawn = true
			}
		}
	}
	return out
}
let intro_story_entities

await Deno.writeTextFile('./maps/intro-story-concat.map', `
// Game: SNALD
// Format: Standard
// entity 0
{
${worldspawn_section(default_map)}
${worldspawn_section(intro_story_map).slice(62) }
}
${entities_section(default_map)}
${entities_section(intro_story_map)}
`)