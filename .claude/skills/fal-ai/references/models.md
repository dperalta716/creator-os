# fal.ai Model Reference

## Image Generation Models

| Model | Alias | Endpoint | Cost/img | Speed | Best For |
|-------|-------|----------|----------|-------|----------|
| GPT Image 2 | `gpt2` | `openai/gpt-image-2` | $0.006 (low) – $0.21 (high) | ~3s | Text in images, prompt adherence, UI mockups |
| Nano Banana | `banana` | `fal-ai/nano-banana` | ~$0.04 | Fastest | Artistic exploration, rapid concept drafts |
| Nano Banana 2 | `banana2` | `fal-ai/nano-banana-2` | ~$0.08 | 4-8s | Production work, good text, complex scenes |
| Nano Banana Pro | `banana-pro` | `fal-ai/nano-banana-pro` | ~$0.15 | 10-20s | Studio-quality, fine typography, compositions |

## Image Editing Models

All models have `/edit` variants that accept source images + edit prompts.

| Model | Edit Endpoint | Special Features |
|-------|--------------|-----------------|
| GPT Image 2 | `openai/gpt-image-2/edit` | Mask-based inpainting via `mask_url` |
| Nano Banana | `fal-ai/nano-banana/edit` | Prompt-based editing |
| Nano Banana 2 | `fal-ai/nano-banana-2/edit` | Prompt-based, thinking modes |
| Nano Banana Pro | `fal-ai/nano-banana-pro/edit` | Prompt-based, highest quality |

## GPT Image 2 Parameters

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| `prompt` | string | required | Text description |
| `image_size` | enum/object | landscape_4_3 | Preset or `{width, height}` |
| `quality` | enum | low | `low`, `medium`, `high` — affects detail + cost |
| `num_images` | integer | 1 | Images to generate |
| `output_format` | enum | png | `png`, `jpeg`, `webp` |

Quality tiers (1024x1024): low=$0.006, medium=$0.053, high=$0.211

Image size presets: `square_hd`, `square`, `portrait_4_3`, `portrait_16_9`, `landscape_4_3`, `landscape_16_9`

Custom size constraints: multiples of 16, max edge 3840px, aspect ratio max 3:1

## Nano Banana 2 Parameters

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| `prompt` | string | required | Text description |
| `aspect_ratio` | enum | auto | `1:1`, `16:9`, `9:16`, `4:3`, `3:4`, `21:9`, etc. |
| `resolution` | enum | 1K | `0.5K`, `1K`, `2K`, `4K` |
| `num_images` | integer | 1 | Images to generate |
| `output_format` | enum | png | `png`, `jpeg`, `webp` |
| `safety_tolerance` | enum | 4 | 1 (strict) – 6 (permissive) |
| `thinking_level` | enum | — | `minimal`, `high` |
| `enable_web_search` | boolean | — | Use web info for generation |

## Nano Banana Pro Parameters

Same as Nano Banana 2 except:
- No `0.5K` resolution option (1K, 2K, 4K only)
- No `thinking_level` parameter
- Higher quality output, especially for complex compositions

## Nano Banana (Original) Parameters

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| `prompt` | string | required | Text description |
| `aspect_ratio` | enum | 1:1 | Standard aspect ratios |
| `num_images` | integer | 1 | Images to generate |
| `output_format` | enum | png | `png`, `jpeg`, `webp` |

No `resolution` parameter. Based on Gemini 2.5 Flash — diffusion model aesthetic.

## Model Selection Guide

```
Need text in the image? → GPT Image 2 (high quality)
Quick cheap draft? → GPT Image 2 (low quality) at $0.006
Artistic/experimental? → Nano Banana (original)
Production work, balanced cost? → Nano Banana 2
Maximum quality, complex scene? → Nano Banana Pro
Editing with a mask? → GPT Image 2 Edit
Prompt-based editing? → Any Nano Banana Edit
```
