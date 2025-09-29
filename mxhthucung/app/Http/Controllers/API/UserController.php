<?php

namespace App\Http\Controllers\API;

use App\Http\Controllers\Controller;
use Illuminate\Http\Request;
use App\Models\User;

class UserController extends Controller
{
    
    // Trả về danh sách tất cả người dùng (nếu cần)
    public function index()
    {
        return response()->json(User::all());
    }

    // Cập nhật ngôn ngữ người dùng
    public function updateLanguage(Request $request)
    {
        $request->validate([
            'language' => 'required|in:vi,en',
        ]);

        $user = $request->user();

        if (!$user) {
            return response()->json([
                'status' => 'error',
                'message' => 'Không xác định được người dùng',
            ], 401);
        }

        $user->language = $request->language;
        $user->save();

        return response()->json([
            'status' => 'success',
            'message' => 'Ngôn ngữ đã được cập nhật',
            'language' => $user->language,
        ]);
    }


//dùng để xem hồ sơ người dùng bằng id
public function show($id)
{
    $user = User::find($id);
    if (!$user) {
        return response()->json(['error' => 'Không tìm thấy người dùng'], 404);
    }

    return response()->json([
        'name' => $user->name,
        'email' => $user->email,
        'pet_name' => $user->pet_name,
        'created_at' => $user->created_at,
    ]);
}

}