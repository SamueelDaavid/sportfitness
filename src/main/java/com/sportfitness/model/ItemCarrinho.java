package com.sportfitness.model;

public class ItemCarrinho {
    private int produtoId;
    private String nome;
    private double preco;
    private int quantidade;
    private String imagemUrl;

    public ItemCarrinho() {}

    public ItemCarrinho(int produtoId, String nome, double preco, int quantidade, String imagemUrl) {
        this.produtoId = produtoId;
        this.nome = nome;
        this.preco = preco;
        this.quantidade = quantidade;
        this.imagemUrl = imagemUrl;
    }

    public int getProdutoId() { return produtoId; }
    public void setProdutoId(int produtoId) { this.produtoId = produtoId; }

    public String getNome() { return nome; }
    public void setNome(String nome) { this.nome = nome; }

    public double getPreco() { return preco; }
    public void setPreco(double preco) { this.preco = preco; }

    public int getQuantidade() { return quantidade; }
    public void setQuantidade(int quantidade) { this.quantidade = quantidade; }

    public String getImagemUrl() { return imagemUrl; }
    public void setImagemUrl(String imagemUrl) { this.imagemUrl = imagemUrl; }

    public double getSubtotal() {
        return preco * quantidade;
    }
}