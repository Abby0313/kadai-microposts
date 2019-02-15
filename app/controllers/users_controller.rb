class UsersController < ApplicationController
  before_action :require_user_logged_in, only: [:index, :show, :followings, :followers]

  def index
    @users = User.all.page(params[:page])
  end

  def show
    # User.findはUserクラスのインスタンスを戻り値として返してくる、それを@userで受け取っている
    # @userはインスタンスなので、インスタンスメソッドを実行できる
    # 実はhas_many :micropostsはUserクラスにmicropostsというインスタンスメソッドを定義している（裏で）
    # 実際には
    # def microposts
    # ...
    # end
    # ↑これと同じ
    # なので、@user.micropostsというのは、Userクラスのインスタンスメソッドであるmicropostsを呼び出している
    # @user.micropostsを実行することで、Micropostクラスのインスタンスがたくさん入った配列（のようなもの）が返ってくる
    # [Micropostのインスタンス1, Micropostのインスタンス2,...]
    @user = User.find(params[:id])
    @microposts = @user.microposts.order('created_at DESC').page(params[:page])
    counts(@user)
  end

  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)

    if @user.save
      flash[:success] = 'ユーザを登録しました。'
      redirect_to @user
    else
      flash.now[:danger] = 'ユーザの登録に失敗しました。'
      render :new
    end
  end

  def followings
    @user = User.find(params[:id])
    @followings = @user.followings.page(params[:page])
    counts(@user)
  end
  
  def followers
    @user = User.find(params[:id])
    @followers = @user.followers.page(params[:page])
    counts(@user)
  end

  def likes
    @user = User.find(params[:id])
    @likes = @user.favored_microposts.page(params[:page])
    # デフォルトでは、views/user/likes.html.erbに飛ぶ
  end

  private

  def user_params
    params.require(:user).permit(:name, :email, :password, :password_confirmation)
  end

end
