CREATE TABLE IF NOT EXISTS tickets (
    id SERIAL PRIMARY KEY,
    titulo VARCHAR(255) NOT NULL,
    descricao TEXT NOT NULL,
    status VARCHAR(50) NOT NULL,
    prioridade VARCHAR(50) NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

INSERT INTO tickets (
    titulo,
    descricao,
    status,
    prioridade
)
VALUES
(
    'Primeiro Ticket',
    'Banco inicializado com sucesso.',
    'ABERTO',
    'MEDIA'
);