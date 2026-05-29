const pool = require('../config/db');

const getAllTickets = async (req, res) => {
  try {
    const result = await pool.query(
      'SELECT * FROM tickets ORDER BY id ASC'
    );

    res.json(result.rows);
  } catch (error) {
    console.error(error);

    res.status(500).json({
      error: 'Erro ao buscar tickets'
    });
  }
};

const getTicketById = async (req, res) => {
  try {
    const { id } = req.params;

    const result = await pool.query(
      'SELECT * FROM tickets WHERE id = $1',
      [id]
    );

    if (result.rows.length === 0) {
      return res.status(404).json({
        error: 'Ticket não encontrado'
      });
    }

    res.json(result.rows[0]);
  } catch (error) {
    console.error(error);

    res.status(500).json({
      error: 'Erro ao buscar ticket'
    });
  }
};

const createTicket = async (req, res) => {
  try {
    const {
      titulo,
      descricao,
      status,
      prioridade
    } = req.body;

    const result = await pool.query(
      `
      INSERT INTO tickets
      (titulo, descricao, status, prioridade)
      VALUES ($1, $2, $3, $4)
      RETURNING *
      `,
      [titulo, descricao, status, prioridade]
    );

    res.status(201).json(result.rows[0]);
  } catch (error) {
    console.error(error);

    res.status(500).json({
      error: 'Erro ao criar ticket'
    });
  }
};

const updateTicket = async (req, res) => {
  try {
    const { id } = req.params;

    const {
      titulo,
      descricao,
      status,
      prioridade
    } = req.body;

    const result = await pool.query(
      `
      UPDATE tickets
      SET
        titulo = $1,
        descricao = $2,
        status = $3,
        prioridade = $4
      WHERE id = $5
      RETURNING *
      `,
      [titulo, descricao, status, prioridade, id]
    );

    if (result.rows.length === 0) {
      return res.status(404).json({
        error: 'Ticket não encontrado'
      });
    }

    res.json(result.rows[0]);
  } catch (error) {
    console.error(error);

    res.status(500).json({
      error: 'Erro ao atualizar ticket'
    });
  }
};

const deleteTicket = async (req, res) => {
  try {
    const { id } = req.params;

    const result = await pool.query(
      'DELETE FROM tickets WHERE id = $1 RETURNING *',
      [id]
    );

    if (result.rows.length === 0) {
      return res.status(404).json({
        error: 'Ticket não encontrado'
      });
    }

    res.json({
      message: 'Ticket removido com sucesso'
    });
  } catch (error) {
    console.error(error);

    res.status(500).json({
      error: 'Erro ao remover ticket'
    });
  }
};

module.exports = {
  getAllTickets,
  getTicketById,
  createTicket,
  updateTicket,
  deleteTicket
};