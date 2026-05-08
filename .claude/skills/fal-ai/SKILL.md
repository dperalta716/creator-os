---
name: fal-ai
description: Generate and edit images using fal.ai API. Use this skill whenever the user asks to generate an image, create a picture, make artwork, edit a photo, modify an image, or anything involving AI image generation or editing. Trigger on phrases like "generate an image", "create a picture of", "make me an image", "edit this image", "modify this photo", "draw", "illustrate", or when the user describes a visual scene they want created. Default model is GPT Image 2 at low quality, 1024x1024.
---

# fal.ai Image Generation & Editing

## Apply Learnings

Before starting, read `learnings.md` in this skill's directory for accumulated rules from past usage.

## Quick Reference

### Generate an image (default: GPT Image 2, low quality, 1024x1024)
```bash
~/.claude/skills/fal-ai/scripts/fal-generate-image.sh "a sunset over mountains"
```

### Generate with a specific model
```bash
~/.claude/skills/fal-ai/scripts/fal-generate-image.sh "a sunset over mountains" banana2
```

### Edit an image
```bash
~/.claude/skills/fal-ai/scripts/fal-edit-image.sh "make the sky purple" "https://example.com/photo.jpg"
~/.claude/skills/fal-ai/scripts/fal-edit-image.sh "add a hat to the person" "/path/to/local/image.png"
```

## Model Selection

Pick the right model based on what's needed:

| Need | Model | Alias |
|------|-------|-------|
| Default / cheap drafts | GPT Image 2 (low) | `gpt2` |
| Perfect text in image | GPT Image 2 (high) | `gpt2` + quality `high` |
| Artistic / experimental | Nano Banana | `banana` |
| Balanced production | Nano Banana 2 | `banana2` |
| Maximum quality | Nano Banana Pro | `banana-pro` |

If the user doesn't specify a model, use `gpt2` (GPT Image 2) with quality `low` and size `1024x1024`.

If the user asks for higher quality, switch quality to `high` before switching models. If they ask for "artistic" or "painterly" style, suggest `banana`. If they want the best possible output, suggest `banana-pro`.

For detailed model parameters and pricing, read `references/models.md`.

## Scripts

### Image Generation

```
~/.claude/skills/fal-ai/scripts/fal-generate-image.sh "prompt" [model] [size] [quality] [format] [num_images]
```

| Param | Default | Options |
|-------|---------|---------|
| `prompt` | required | Text description of desired image |
| `model` | `gpt2` | `gpt2`, `banana`, `banana2`, `banana-pro` |
| `size` | `1024x1024` | `WxH` or aspect ratio (`16:9`, `1:1`, etc.) |
| `quality` | `low` | `low`, `medium`, `high` (GPT Image 2 only) |
| `format` | `png` | `png`, `jpeg`, `webp` |
| `num_images` | `1` | Number of images to generate |

The script outputs the downloaded file path to stdout. All images download to `~/Downloads/`.

### Image Editing

```
~/.claude/skills/fal-ai/scripts/fal-edit-image.sh "prompt" "image" [model] [quality] [format]
```

| Param | Default | Options |
|-------|---------|---------|
| `prompt` | required | Description of desired edit |
| `image` | required | URL or local file path |
| `model` | `gpt2` | `gpt2`, `banana`, `banana2`, `banana-pro` |
| `quality` | `low` | `low`, `medium`, `high` (GPT Image 2 only) |
| `format` | `png` | `png`, `jpeg`, `webp` |

Local files are automatically converted to data URIs. Edited images download to `~/Downloads/`.

## Workflow

1. Determine if the user wants generation or editing
2. Select the appropriate model (default: `gpt2`)
3. Run the script with the user's prompt
4. After the script completes, read the downloaded image to show the user the result
5. Ask if they want adjustments (different model, size, prompt refinement, etc.)

## API Key

Stored at `.claude/skills/fal-ai/fal-api-key` (or `~/.claude/skills/fal-api-key` as fallback). The scripts load this automatically.

## Rules

*Updated when the user flags issues. Read before every run.*

- Default to GPT Image 2, quality=low, size=1024x1024 unless the user specifies otherwise
- After generating, always read the downloaded file so the user can see the result
- If generation fails, check the error — common issues are invalid size dimensions or API rate limits

## Self-Update

When the user provides feedback about wrong output, bad quality, wrong model selection, or unexpected behavior:

1. Fix the current output based on the feedback
2. Fix the source — update the script or SKILL.md step that caused the problem
3. Add a Rule if the mistake might recur in a future session
4. Log to `learnings.md` only if the failure story adds context the fix alone doesn't convey

## Feedback Collection

After completing a generation or edit, note any issues with the output quality, model selection, or workflow. If the user corrects the approach, capture it as a learning.
