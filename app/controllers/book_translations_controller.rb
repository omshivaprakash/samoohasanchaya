class BookTranslationsController < ApplicationController

  def index
    translated_books = Book.where("id in (?)", BookTranslation.pluck('book_id'))
    @books = translated_books.paginate(:page => params[:page], :per_page => 30)
  end

  def new
    @book = Book.find(params['book_id'])
    @translation = @book.book_translations.new
  end

  def create
    @book = Book.find(params['book_id'])
    @translation = @book.book_translations.new(book_translation_params)
    @translation.language_id = Language.first.id
    respond_to do |format|
      if @translation.save
        format.html { redirect_to books_path, notice: 'Book was successfully updated.' }
        format.json { render :show, status: :ok, location: @book }
      else
        format.html { render :edit }
        format.json { render json: @book.errors, status: :unprocessable_entity }
      end
    end
  end

  private
    # Never trust parameters from the scary internet, only allow the white list through.
    def book_translation_params
      params.require(:book_translation).permit(:author, :book_title, :publisher)
    end
  end
