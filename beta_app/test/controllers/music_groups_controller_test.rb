require 'test_helper'

class MusicGroupsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @music_group = music_groups(:one)
  end

  test "should get index" do
    get music_groups_url
    assert_response :success
  end

  test "should get new" do
    get new_music_group_url
    assert_response :success
  end

  test "should create music_group" do
    assert_difference('MusicGroup.count') do
      post music_groups_url, params: { music_group: { bio: @music_group.bio, name: @music_group.name, user_id: @music_group.user_id } }
    end

    assert_redirected_to music_group_url(MusicGroup.last)
  end

  test "should show music_group" do
    get music_group_url(@music_group)
    assert_response :success
  end

  test "should get edit" do
    get edit_music_group_url(@music_group)
    assert_response :success
  end

  test "should update music_group" do
    patch music_group_url(@music_group), params: { music_group: { bio: @music_group.bio, name: @music_group.name, user_id: @music_group.user_id } }
    assert_redirected_to music_group_url(@music_group)
  end

  test "should destroy music_group" do
    assert_difference('MusicGroup.count', -1) do
      delete music_group_url(@music_group)
    end

    assert_redirected_to music_groups_url
  end
end
