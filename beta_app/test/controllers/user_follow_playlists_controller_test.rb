require 'test_helper'

class UserFollowPlaylistsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @user_follow_playlist = user_follow_playlists(:one)
  end

  test "should get index" do
    get user_follow_playlists_url
    assert_response :success
  end

  test "should get new" do
    get new_user_follow_playlist_url
    assert_response :success
  end

  test "should create user_follow_playlist" do
    assert_difference('UserFollowPlaylist.count') do
      post user_follow_playlists_url, params: { user_follow_playlist: {  } }
    end

    assert_redirected_to user_follow_playlist_url(UserFollowPlaylist.last)
  end

  test "should show user_follow_playlist" do
    get user_follow_playlist_url(@user_follow_playlist)
    assert_response :success
  end

  test "should get edit" do
    get edit_user_follow_playlist_url(@user_follow_playlist)
    assert_response :success
  end

  test "should update user_follow_playlist" do
    patch user_follow_playlist_url(@user_follow_playlist), params: { user_follow_playlist: {  } }
    assert_redirected_to user_follow_playlist_url(@user_follow_playlist)
  end

  test "should destroy user_follow_playlist" do
    assert_difference('UserFollowPlaylist.count', -1) do
      delete user_follow_playlist_url(@user_follow_playlist)
    end

    assert_redirected_to user_follow_playlists_url
  end
end
