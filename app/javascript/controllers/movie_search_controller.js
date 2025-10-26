// app/javascript/controllers/movie_search_controller.js
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
    this.clearMessage(); // Limpa mensagens anteriores

    try {
      // AJUSTE AQUI: Use a rota Rails correta /movies/search_ai
      const response = await fetch(`/movies/search_ai?title=${encodeURIComponent(title)}`);

      if (!response.ok) {
        // Se a resposta for um erro HTTP (4xx, 5xx), o backend já deve ter enviado um JSON com 'error'
        const errorData = await response.json();
        throw new Error(errorData.error || `Erro na busca: ${response.statusText}`);
      }

      const data = await response.json();

      if (data.error) {
        // Se o backend retornou 200 OK mas com um campo 'error' no JSON (ex: filme não encontrado)
        this.showError(data.error);
        return;
      }

      // Preenche os campos do formulário com os dados da IA
      this.synopsisTarget.value = data.synopsis || '';
      this.releaseYearTarget.value = data.release_year || '';
      this.durationTarget.value = data.duration || '';
      this.directorTarget.value = data.director || '';
      // Se você tiver um campo para cast, adicione também:
      // this.castTarget.value = data.cast || '';

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
    this.errorMessageTarget.className = "alert alert-danger"; // Utilize classes CSS para estilizar
    this.errorMessageTarget.style.display = "block";
  }

  showMessage(message, type = "info") {
    this.errorMessageTarget.textContent = message;
    this.errorMessageTarget.className = `alert alert-${type}`; // Use 'alert-success' para sucesso
    this.errorMessageTarget.style.display = "block";
  }

  clearMessage() {
    this.errorMessageTarget.textContent = "";
    this.errorMessageTarget.style.display = "none";
    this.errorMessageTarget.className = "alert";
  }
}