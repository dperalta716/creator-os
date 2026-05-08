#!/usr/bin/env node
import { chromium } from 'playwright';
import { readFileSync } from 'fs';

const url = process.argv[2];
if (!url) {
  console.error('Usage: node scrape-medium.mjs <medium-url>');
  process.exit(1);
}

const authFile = new URL('./auth.json', import.meta.url).pathname;

let storageState;
try {
  storageState = JSON.parse(readFileSync(authFile, 'utf-8'));
} catch {
  console.error('❌ No auth.json found. Run: node login.mjs');
  process.exit(1);
}

const browser = await chromium.launch({
  headless: false,
  args: ['--disable-blink-features=AutomationControlled']
});

const context = await browser.newContext({ storageState });
const page = await context.newPage();

await page.goto(url, { waitUntil: 'networkidle' });
await page.waitForTimeout(2000);

const article = await page.evaluate(() => {
  const el = document.querySelector('article');
  if (!el) return null;

  function nodeToMarkdown(node, depth = 0) {
    if (node.nodeType === Node.TEXT_NODE) return node.textContent;
    if (node.nodeType !== Node.ELEMENT_NODE) return '';

    const tag = node.tagName.toLowerCase();
    const children = Array.from(node.childNodes).map(c => nodeToMarkdown(c, depth)).join('');

    switch (tag) {
      case 'h1': return `# ${children.trim()}\n\n`;
      case 'h2': return `## ${children.trim()}\n\n`;
      case 'h3': return `### ${children.trim()}\n\n`;
      case 'h4': return `#### ${children.trim()}\n\n`;
      case 'p': return `${children.trim()}\n\n`;
      case 'strong':
      case 'b': return `**${children.trim()}**`;
      case 'em':
      case 'i': return `*${children.trim()}*`;
      case 'a': {
        const href = node.getAttribute('href');
        return href ? `[${children.trim()}](${href})` : children;
      }
      case 'img': {
        const src = node.getAttribute('src') || '';
        const alt = node.getAttribute('alt') || '';
        return `![${alt}](${src})\n\n`;
      }
      case 'figure': return children;
      case 'figcaption': return `*${children.trim()}*\n\n`;
      case 'blockquote': return `> ${children.trim()}\n\n`;
      case 'code': {
        if (node.parentElement?.tagName.toLowerCase() === 'pre') return children;
        return `\`${children}\``;
      }
      case 'pre': return `\`\`\`\n${children.trim()}\n\`\`\`\n\n`;
      case 'ul': return children + '\n';
      case 'ol': return children + '\n';
      case 'li': {
        const parent = node.parentElement?.tagName.toLowerCase();
        const idx = Array.from(node.parentElement?.children || []).indexOf(node);
        const prefix = parent === 'ol' ? `${idx + 1}. ` : '- ';
        return `${prefix}${children.trim()}\n`;
      }
      case 'br': return '\n';
      case 'hr': return '---\n\n';
      case 'div':
      case 'section':
      case 'span':
        return children;
      default: return children;
    }
  }

  return nodeToMarkdown(el);
});

await browser.close();

if (!article) {
  console.error('❌ No <article> element found on page');
  process.exit(1);
}

const cleaned = article
  .replace(/\n{3,}/g, '\n\n')
  .trim();

process.stdout.write(cleaned);
