import { chromium } from 'playwright';

const authFile = new URL('./auth.json', import.meta.url).pathname;

const browser = await chromium.launch({
  headless: false,
  args: ['--disable-blink-features=AutomationControlled']
});

const context = await browser.newContext();
const page = await context.newPage();

await page.goto('https://medium.com/m/signin');

console.log('\n🔑 Log into Medium in the browser window.');
console.log('   Once you see your Medium homepage, press Enter here.\n');

await new Promise(resolve => {
  process.stdin.once('data', resolve);
});

await context.storageState({ path: authFile });
console.log(`✅ Auth saved to ${authFile}`);

await browser.close();
process.exit(0);
