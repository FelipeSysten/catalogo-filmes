import { Controller } from "@hotwired/stimulus";

export default class extends Controller {
  static targets = ["title", "synopsis", "releaseYear", "duration", "director", "searchButton", "errorMessage"];

  connect() {
    console.log("Movie Search Controller connected!");
  }

  async search() {
    const title = this.titleTarget.value;
    if (!title) {
      this.showError("Por favor, insira um título para buscar.");
      return;
    }

    this.searchButtonTarget.disabled = true;
    this.searchButtonTarget.textContent = "Buscando...";
    this.clearMessage(); 

    try {
      
      const response = await fetch(`/movies/search_ai?title=${encodeURIComponent(title)}`);

      if (!response.ok) {
       
        const errorData = await response.json();
        throw new Error(errorData.error || `Erro na busca: ${response.statusText}`);
      }

      const data = await response.json();

      if (data.error) {
        
        this.showError(data.error);
        return;
      }

     
      this.synopsisTarget.value = data.synopsis || '';
      this.releaseYearTarget.value = data.release_year || '';
      this.durationTarget.value = data.duration || '';
      this.directorTarget.value = data.director || '';
      

      this.showMessage("Dados preenchidos com sucesso!", "success");

    } catch (error) {
      console.error("Erro ao buscar filme por IA:", error);
      this.showError(`Não foi possível buscar o filme: ${error.message}`);
    } finally {
      this.searchButtonTarget.disabled = false;
      this.searchButtonTarget.textContent = "Buscar por IA";
    }
  }

  showError(message) {
    this.errorMessageTarget.textContent = message;
    this.errorMessageTarget.className = "alert alert-danger"; 
    this.errorMessageTarget.style.display = "block";
  }

  showMessage(message, type = "info") {
    this.errorMessageTarget.textContent = message;
    this.errorMessageTarget.className = `alert alert-${type}`; 
    this.errorMessageTarget.style.display = "block";
  }

  clearMessage() {
    this.errorMessageTarget.textContent = "";
    this.errorMessageTarget.style.display = "none";
    this.errorMessageTarget.className = "alert";
  }
}