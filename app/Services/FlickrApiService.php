<?php

namespace App\services;

use Exception;
use Illuminate\Support\Facades\Http;

class FlickrApiService
{
    public function getPublicFeeds($tags)
    {
        $url = env('FLICKR_ENDPOINT') . '/photos_public.gne';

        try {
            $response = Http::get($url, [
                'format' => 'json',
                'nojsoncallback' => 1,
                'tags' => $tags,
            ]);

            if ($response->successful()) {
                return $response->json();
            }

            $errorDetails = [
                'status' => $response->status(),
                'body' => $response->body(),
            ];

            throw new \Exception("La API no respondió correctamente. Detalles: " . json_encode($errorDetails));
        } catch (Exception $e) {
            throw new \Exception("Error al obtener los feeds públicos: " . $e->getMessage());
        }
    }
}
