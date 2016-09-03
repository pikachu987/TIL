package com.company;

import java.util.List;

import javax.xml.bind.annotation.XmlAccessType;
import javax.xml.bind.annotation.XmlAccessorType;
import javax.xml.bind.annotation.XmlElement;
import javax.xml.bind.annotation.XmlRootElement;

@XmlAccessorType(XmlAccessType.FIELD)
@XmlRootElement(name = "element-list")
public class ListXml {

	@XmlElement(name = "element")
	private List<Element> element;

	public ListXml(List<Element> element) {
		this.element = element;
	}
	
	public ListXml() {
		super();
	}

	public List<Element> getElement() {
		return element;
	}

	public void setElement(List<Element> element) {
		this.element = element;
	}

}