<?php

namespace App\Http\Controllers\API;

use App\Http\Controllers\Controller;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Auth;
use Illuminate\Support\Facades\Validator;

class SettingsController extends Controller
{
    public function getSettings(Request $request)
    {
        $user = $request->user();

        return response()->json([
            'theme' => $user->theme ?? 'system',
            'language' => $user->language ?? 'vi',
            'push_notifications' => $user->push_notifications ?? false,
            'sound_notifications' => $user->sound_notifications ?? false,
            'in_app_notifications' => $user->in_app_notifications ?? true,
            'private_account' => $user->private_account ?? false,
            'show_online_status' => $user->show_online_status ?? false,
            'two_factor_enabled' => $user->two_factor_enabled ?? false,
        ]);
    }
        
        public function update(Request $request)
    {
        $user = auth()->user();

        $request->validate([
            'language' => 'required|in:vi,en',
        ]);

        $user->language = $request->language;
        $user->save();

        return response()->json(['message' => 'Ngôn ngữ đã được cập nhật']);
    }

}