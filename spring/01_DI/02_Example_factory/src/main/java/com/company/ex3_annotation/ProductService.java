package com.company.ex3_annotation;

import javax.annotation.Resource;

import org.springframework.stereotype.Component;

import com.company.ex2_factory.SearchClientFactory;
import com.company.ex2_factory.SearchDocument;

@Component
public class ProductService {

	private SearchClientFactory searchClientFactory;

	@Resource(name = "productSearchClientFactory")
	public void setSearchClientFactory(SearchClientFactory searchClientFactory) {
		this.searchClientFactory = searchClientFactory;
	}

	public void createProduct(ProductInfo pi) {
		searchClientFactory.create().addDocument(toSearchDocument(pi));
	}

	private SearchDocument toSearchDocument(ProductInfo pi) {
		return new SearchDocument();
	}
}
