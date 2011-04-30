package de.hsharz.game.client;

import com.google.gwt.dom.client.AudioElement;
import com.google.gwt.dom.client.MediaElement;
import com.google.gwt.media.client.Audio;
import com.google.gwt.user.client.ui.RootPanel;

import de.hsharz.game.engine.Sound;

public class WebSound implements Sound {
	private AudioElement element;
	
	public WebSound(String filename) {
		Audio audio = Audio.createIfSupported(); //not supported in IE9
		if (audio != null) {
			RootPanel.get().add(audio);
			element = audio.getAudioElement();
			element.setSrc(filename + ".wav");
			element.setPreload(MediaElement.PRELOAD_AUTO);
		}
	}
	
	@Override
	public void play() {
		if (element == null) return;
		element.setCurrentTime(0);
		element.play();
	}
}