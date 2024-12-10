<?php

namespace App\Http\Controllers\Api\V1;

use App\Http\Controllers\Controller;
use App\Http\Resources\Api\V1\PublicFeedResource;
use App\Services\FlickrApiService;
use Illuminate\Http\Request;

class FeedController extends Controller
{
    protected $flickrApiService;

    public function __construct(FlickrApiService $flickrApiService)
    {
        $this->flickrApiService = $flickrApiService;
    }

    public function index(Request $request)
    {
        $tags = trim($request->tags) ?: '';

        try {
            $response = $this->flickrApiService->getPublicFeeds($tags);

            if (!empty($response['items'])) {
                return response()->json([
                    'message' => 'Lista de feeds públicos',
                    'data' => PublicFeedResource::collection($response['items']),
                    'error' => null,
                ], 200);
            }

            return response()->json([
                'message' => 'No hay data disponible',
                'data' => [],
                'error' => null,
            ], 200);
        } catch (\Throwable $th) {
            return response()->json([
                'data' => [],
                'message' => 'Hubo un error al obtener la lista de feeds públicos',
                'error' => $th->getMessage(),
            ], 500);
        }
    }
}
