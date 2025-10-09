<?php

namespace App\Http\Controllers\API;

use App\Http\Controllers\Controller;
use Illuminate\Http\Request;
use App\Models\User;
use Illuminate\Support\Facades\Hash;
use Illuminate\Support\Facades\Storage;

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

    // Xem hồ sơ người dùng bằng id
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
            'phone' => $user->phone ?? '',
            'avatar_url' => $user->avatar ? url('storage/' . $user->avatar) : null,
            'created_at' => $user->created_at,
        ]);
    }

    // Upload avatar
    public function uploadAvatar(Request $request, $id)
    {
        $user = $request->user();
        
        // Kiểm tra quyền (chỉ user mới được update avatar của chính mình)
        if ($user->id != $id) {
            return response()->json(['error' => 'Unauthorized'], 403);
        }

        $request->validate([
            'avatar' => 'required|image|mimes:jpeg,png,jpg,gif|max:2048',
        ]);

        try {
            // Xóa avatar cũ nếu có
            if ($user->avatar && Storage::disk('public')->exists($user->avatar)) {
                Storage::disk('public')->delete($user->avatar);
            }

            // Lưu avatar mới
            $path = $request->file('avatar')->store('avatars', 'public');
            $user->avatar = $path;
            $user->save();

            return response()->json([
                'message' => 'Upload avatar thành công',
                'avatar_url' => url('storage/' . $path),
            ], 200);
        } catch (\Exception $e) {
            return response()->json([
                'error' => 'Upload avatar thất bại',
                'message' => $e->getMessage(),
            ], 500);
        }
    }

    // Cập nhật thông tin user
    public function update(Request $request, $id)
    {
        $user = $request->user();
        
        // Kiểm tra quyền
        if ($user->id != $id) {
            return response()->json(['error' => 'Unauthorized'], 403);
        }

        $request->validate([
            'name' => 'sometimes|string|max:255',
            'pet_name' => 'sometimes|string|max:255',
            'phone' => 'sometimes|string|max:20',
        ]);

        try {
            if ($request->has('name')) {
                $user->name = $request->name;
            }
            if ($request->has('pet_name')) {
                $user->pet_name = $request->pet_name;
            }
            if ($request->has('phone')) {
                $user->phone = $request->phone;
            }

            $user->save();

            return response()->json([
                'message' => 'Cập nhật thông tin thành công',
                'user' => [
                    'name' => $user->name,
                    'email' => $user->email,
                    'pet_name' => $user->pet_name,
                    'phone' => $user->phone ?? '',
                ],
            ], 200);
        } catch (\Exception $e) {
            return response()->json([
                'error' => 'Cập nhật thất bại',
                'message' => $e->getMessage(),
            ], 500);
        }
    }

    // Đổi mật khẩu
    public function changePassword(Request $request)
    {
        $request->validate([
            'current_password' => 'required',
            'new_password' => 'required|min:6',
        ]);

        $user = $request->user();

        // Kiểm tra mật khẩu hiện tại
        if (!Hash::check($request->current_password, $user->password)) {
            return response()->json([
                'error' => 'Mật khẩu hiện tại không đúng',
            ], 400);
        }

        try {
            $user->password = Hash::make($request->new_password);
            $user->save();

            return response()->json([
                'message' => 'Đổi mật khẩu thành công',
            ], 200);
        } catch (\Exception $e) {
            return response()->json([
                'error' => 'Đổi mật khẩu thất bại',
                'message' => $e->getMessage(),
            ], 500);
        }
    }

}