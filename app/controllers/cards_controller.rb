class CardsController < ApplicationController

  load_and_authorize_resource
  before_action :set_card, only: [:show, :edit, :update, :destroy]

  # GET /cards
  # GET /cards.json
  def index
    if current_user
      @cards = current_user.cards
    else
      @cards = Card.where(user_id: nil)
    end
  end

  # GET /cards/1
  # GET /cards/1.json
  def show
  end


  # GET /cards/new
  def new
    @card = Card.new
  end

  # GET /cards/1/edit
  def edit
  end

  # POST /cards
  # POST /cards.json
  def create
    @card = Card.new(card_params)
    @card.user_id = current_user.id
    topic = Topic.find(params[:card][:topic_id])

    # @card = Card.new(add_user_id(card_params)
    #взять из параметров идентификатор id топика
    #нйати топик по этому айди
    # сравнить user_id топика с current_user id
    # и если он совпадает, то выполнить сохранение

    respond_to do |format|
      if topic.user_id == current_user.id
        if @card.save
          format.html { redirect_to cards_url }
          format.json { render :show, status: :created, location: @card }
        else
          format.html { render :new }
          format.json { render json: @card.errors, status: :unprocessable_entity }
        end
      else
        format.html { render :new }
        format.json { render json: @card.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /cards/1
  # PATCH/PUT /cards/1.json
  def update
    respond_to do |format|
      if @card.update(card_params)
        format.html { redirect_to cards_url }
        format.json { render :show, status: :ok, location: @card }
      else
        format.html { render :edit }
        format.json { render json: @card.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /cards/1
  # DELETE /cards/1.json
  def destroy
    @card.destroy
    respond_to do |format|
      format.html { redirect_to cards_url }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_card
      @card = Card.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def card_params
      params.require(:card).permit(:question, :answer, :topic_id, :image, :memorization_level)
    end
end
