<?php

namespace App\Http\Controllers\API;

use App\Http\Controllers\Controller;
use Illuminate\Http\Request;
use App\Models\User;
use App\Models\Follow;

class FollowController extends Controller
{
    // Toggle follow/unfollow user
    public function toggle(Request $request, $userId)
    {
        $currentUser = $request->user();
        
        if ($currentUser->id == $userId) {
            return response()->json(['error' => 'Không thể theo dõi chính mình'], 400);
        }

        $targetUser = User::find($userId);
        if (!$targetUser) {
            return response()->json(['error' => 'Không tìm thấy người dùng'], 404);
        }

        $follow = Follow::where('follower_id', $currentUser->id)
                       ->where('following_id', $userId)
                       ->first();

        if ($follow) {
            // Unfollow
            $follow->delete();
            return response()->json([
                'following' => false,
                'message' => 'Đã bỏ theo dõi'
            ]);
        } else {
            // Follow
            Follow::create([
                'follower_id' => $currentUser->id,
                'following_id' => $userId
            ]);
            return response()->json([
                'following' => true,
                'message' => 'Đã theo dõi'
            ]);
        }
    }

    // Kiểm tra trạng thái follow
    public function checkStatus(Request $request, $userId)
    {
        $currentUser = $request->user();
        
        $isFollowing = Follow::where('follower_id', $currentUser->id)
                            ->where('following_id', $userId)
                            ->exists();

        return response()->json([
            'following' => $isFollowing
        ]);
    }

    // Lấy số lượng followers và following
    public function getStats($userId)
    {
        $followersCount = Follow::where('following_id', $userId)->count();
        $followingCount = Follow::where('follower_id', $userId)->count();

        return response()->json([
            'followers_count' => $followersCount,
            'following_count' => $followingCount
        ]);
    }

    // Danh sách người đang theo dõi user (followers)
    public function getFollowers(Request $request, $userId)
    {
        $followers = Follow::where('following_id', $userId)
            ->with('follower:id,name,pet_name,avatar')
            ->get()
            ->map(function($follow) {
                return [
                    'id' => $follow->follower->id,
                    'name' => $follow->follower->name,
                    'pet_name' => $follow->follower->pet_name ?? '',
                    'avatar_url' => $follow->follower->avatar 
                        ? url('storage/' . $follow->follower->avatar) 
                        : null,
                    'followed_at' => $follow->created_at,
                ];
            });

        return response()->json([
            'followers' => $followers,
            'total' => $followers->count()
        ]);
    }

    // Danh sách người mà user đang theo dõi (following)
    public function getFollowing(Request $request, $userId)
    {
        $following = Follow::where('follower_id', $userId)
            ->with('following:id,name,pet_name,avatar')
            ->get()
            ->map(function($follow) {
                return [
                    'id' => $follow->following->id,
                    'name' => $follow->following->name,
                    'pet_name' => $follow->following->pet_name ?? '',
                    'avatar_url' => $follow->following->avatar 
                        ? url('storage/' . $follow->following->avatar) 
                        : null,
                    'followed_at' => $follow->created_at,
                ];
            });

        return response()->json([
            'following' => $following,
            'total' => $following->count()
        ]);
    }
}