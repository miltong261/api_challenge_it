<?php

namespace App\Http\Resources\Api\V1;

use Carbon\Carbon;
use Illuminate\Http\Request;
use Illuminate\Http\Resources\Json\JsonResource;

class PublicFeedResource extends JsonResource
{
    /**
     * Transform the resource into an array.
     *
     * @return array<string, mixed>
     */
    public function toArray(Request $request): array
    {
        return [
            'title' => $this['title'] ?? 'No Title',
            'image' => $this['media']['m'] ?? null,
            'description' => strip_tags($this['description'] ?? 'No Description'),
            'published' => $this->formatPublishedDate($this['published'] ?? null),
            'tags' => $this['tags'] ?? null,
            'author' => $this->extractAuthorName($this['author'] ?? 'Unknown'),
            'author_id' => $this['author_id'] ?? null,
        ];
    }

    private function extractAuthorName($author)
    {
        if (preg_match('/\("([^"]+)"\)/', $author, $matches)) {
            return $matches[1];
        }

        return $author;
    }

    private function formatPublishedDate($date)
    {
        if ($date) {
            try {
                return Carbon::parse($date)->toDateString();
            } catch (\Exception $e) {
                return null;
            }
        }

        return null;
    }
}
