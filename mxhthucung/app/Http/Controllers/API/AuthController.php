<?php

namespace App\Http\Controllers\API;

use App\Http\Controllers\Controller;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Auth;
use Illuminate\Support\Facades\Hash;
use Illuminate\Support\Facades\Validator;
use App\Models\User;
use Laravel\Passport\Passport;
class AuthController extends Controller
{
  

    public function boot()
    {
        $this->registerPolicies();
        Passport::routes(); // ✅ đăng ký route xác thực
    }
    
    // Đăng ký người dùng mới
        public function register(Request $request)
    {
        $validator = Validator::make($request->all(), [
            'name' => 'required|string|max:255',
            'email' => 'required|email|unique:users,email',
            'password' => 'required|min:6|confirmed',
            'pet_name' => 'nullable|string|max:255',

        ]);

        if ($validator->fails()) {
            return response()->json(['errors' => $validator->errors()], 422);
        }

        try {
            $user = User::create([
                'name'     => $request->name,
                'email'    => $request->email,
                'password' => Hash::make($request->password),
                'pet_name' => $request->pet_name,
            ]);

            $token = $user->createToken('LaravelPassportToken')->accessToken;

            return response()->json([
                'user'  => $user,
                'token' => $token,
            ], 201);
        } catch (\Exception $e) {
            return response()->json([
                'error' => 'Đăng ký thất bại',
                'message' => $e->getMessage(),
            ], 500);
        }
    }

    // Đăng nhập
    public function login(Request $request)
    {
        $request->validate([
            'email'    => 'required|email',
            'password' => 'required|string',
        ]);

        if (!Auth::attempt(['email' => $request->email, 'password' => $request->password])) {
            return response()->json(['error' => 'Sai tài khoản hoặc mật khẩu'], 401);
        }

        $user  = Auth::user();
        $token = $user->createToken('LaravelPassportToken')->accessToken;

        return response()->json([
            'user'  => $user,
            'token' => $token,
        ], 200);
    }

    public function me(Request $request)
{
    return response()->json($request->user());
}

    public function update(Request $request)
    {
        $user = $request->user();

        $request->validate([
            'name'     => 'sometimes|string|max:255',
            'email'    => 'sometimes|email|unique:users,email,' . $user->id,
            'password' => 'sometimes|min:6|confirmed',
        ]);

        if ($request->has('name')) {
            $user->name = $request->name;
        }

        if ($request->has('email')) {
            $user->email = $request->email;
        }

        if ($request->has('password')) {
            $user->password = Hash::make($request->password);
        }

        $user->save();

        return response()->json([
            'message' => 'Cập nhật thành công',
            'user'    => $user,
        ]);
    }

    public function destroy(Request $request)
    {
        $user = $request->user();
        $user->delete();

        return response()->json(['message' => 'Tài khoản đã bị xóa']);
    }

    // Đăng xuất
    public function logout(Request $request)
    {
        $request->user()->token()->revoke();
        return response()->json(['message' => 'Đã đăng xuất thành công']);
    }
}