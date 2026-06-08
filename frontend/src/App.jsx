import { useEffect, useState } from 'react';
import axios from 'axios';

const API_URL = '/api';

function App() {
  const [tickets, setTickets] = useState([]);

  const [form, setForm] = useState({
    titulo: '',
    descricao: '',
    status: 'ABERTO',
    prioridade: 'MEDIA'
  });

  async function loadTickets() {
    try {
      const response = await axios.get(`${API_URL}/tickets`);

      setTickets(response.data);
    } catch (error) {
      console.error(error);
    }
  }

  useEffect(() => {
    loadTickets();
  }, []);

  async function createTicket(e) {
    e.preventDefault();

    try {
      await axios.post(`${API_URL}/tickets`, form);

      setForm({
        titulo: '',
        descricao: '',
        status: 'ABERTO',
        prioridade: 'MEDIA'
      });

      loadTickets();
    } catch (error) {
      console.error(error);
    }
  }

  async function deleteTicket(id) {
    try {
      await axios.delete(`${API_URL}/tickets/${id}`);

      loadTickets();
    } catch (error) {
      console.error(error);
    }
  }

  return (
    <div style={styles.container}>
      <h1>AngelDesk</h1>

      <form onSubmit={createTicket} style={styles.form}>
        <input
          type="text"
          placeholder="Título"
          value={form.titulo}
          onChange={(e) =>
            setForm({ ...form, titulo: e.target.value })
          }
          required
        />

        <textarea
          placeholder="Descrição"
          value={form.descricao}
          onChange={(e) =>
            setForm({ ...form, descricao: e.target.value })
          }
          required
        />

        <select
          value={form.prioridade}
          onChange={(e) =>
            setForm({ ...form, prioridade: e.target.value })
          }
        >
          <option value="BAIXA">Baixa</option>
          <option value="MEDIA">Média</option>
          <option value="ALTA">Alta</option>
        </select>

        <button type="submit">
          Criar Ticket
        </button>
      </form>

      <div style={styles.ticketList}>
        {tickets.map((ticket) => (
          <div key={ticket.id} style={styles.card}>
            <h3>{ticket.titulo}</h3>

            <p>{ticket.descricao}</p>

            <p>
              <strong>Status:</strong> {ticket.status}
            </p>

            <p>
              <strong>Prioridade:</strong> {ticket.prioridade}
            </p>

            <button
              onClick={() => deleteTicket(ticket.id)}
            >
              Remover
            </button>
          </div>
        ))}
      </div>
    </div>
  );
}

const styles = {
  container: {
    maxWidth: '900px',
    margin: '0 auto',
    padding: '20px',
    fontFamily: 'Arial'
  },

  form: {
    display: 'flex',
    flexDirection: 'column',
    gap: '10px',
    marginBottom: '30px'
  },

  ticketList: {
    display: 'grid',
    gap: '15px'
  },

  card: {
    border: '1px solid #ccc',
    borderRadius: '8px',
    padding: '15px'
  }
};

export default App;