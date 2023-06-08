package Disambiguate;

import java.util.ArrayList;
import java.util.List;

import it.uniroma1.lcl.babelfy.commons.BabelfyParameters;
import it.uniroma1.lcl.babelfy.commons.BabelfyParameters.MCS;
import it.uniroma1.lcl.babelfy.commons.BabelfyParameters.MatchingType;
import it.uniroma1.lcl.babelfy.commons.BabelfyParameters.ScoredCandidates;
import it.uniroma1.lcl.babelfy.commons.BabelfyToken;
import it.uniroma1.lcl.babelfy.commons.annotation.CharOffsetFragment;
import it.uniroma1.lcl.babelfy.commons.annotation.SemanticAnnotation;
import it.uniroma1.lcl.babelfy.commons.annotation.TokenOffsetFragment;
import it.uniroma1.lcl.babelfy.core.Babelfy;
import it.uniroma1.lcl.jlt.util.Language;

public class Disambiguator
{
	private static Babelfy bfy;
	private static Language language;
	private static BabelfyParameters bp;

	public Disambiguator()
	{
		configure();
		//language = Language.EN;
		language = Language.FR;
	}

	public Disambiguator(Language lang)
	{
		configure();
		language = lang;
	}

	public Disambiguator(String lang)
	{
		configure();
		language = getLanguage(lang);
	}

	private void configure()
	{
		bp = new BabelfyParameters();
		// MatchingType.EXACT_MATCHING // MatchingType.PARTIAL_MATCHING
		bp.setMatchingType(MatchingType.EXACT_MATCHING);
		// MCS.ON // MCS.ON_WITH_STOPWORDS // MCS.OFF // (Most Common Sense)
		bp.setMCS(MCS.ON_WITH_STOPWORDS);
		// ScoredCandidates.TOP // ScoredCandidates.ALL
		bp.setScoredCandidates(ScoredCandidates.TOP);

		bfy = new Babelfy(bp);
	}

	private static Language getLanguage(String lang)
	{
		Language outLang = Language.EN;
		System.out.println("Language detection (english by default)");

		if (lang.equals("FR"))
		{
			System.out.println("French detected");
			outLang = Language.FR;
		}
		if (lang.equals("EN"))
		{
			System.out.println("English detected");
			outLang = Language.EN;
		}

		return (outLang);
	}

	// $csv_array[] = array("$tokens", "$score", "$coherenceScore", "$globalScore", "$synsetId");

	//BabelFy a string (get the senses)
	public List<List<String> > BabelFyString(String inputText)
	{
		//List<String> FileList = new ArrayList<String>();
		List<SemanticAnnotation> annotationsList;
		List<List<String> > DefinitionList = new ArrayList<>();
		//List<String> charTokens = new ArrayList<String>();

		/*
		//building tokens for the English text
		List<SemanticAnnotation> bfyAnnotations = bfy.babelfy(inputText, Language.EN);
		List<BabelfyToken> tokenizedInput = new ArrayList<>();

		for (String word : myEnText)
			tokenizedInput.add(new BabelfyToken(word, language));

		//add an EOS token to separate the different texts
		tokenizedInput.add(BabelfyToken.EOS);
		*/

		annotationsList = bfy.babelfy(inputText, language);

		for (SemanticAnnotation annotation : annotationsList)
		{
			List<String> Line = new ArrayList<String>();
			String synsetID = annotation.getBabelSynsetID();
			double score = annotation.getScore();
			double coherenceScore = annotation.getCoherenceScore();
			double globalScore = annotation.getGlobalScore();

			CharOffsetFragment cfFrag = annotation.getCharOffsetFragment();
			String charTok = inputText.substring(cfFrag.getStart(), cfFrag.getEnd() + 1);
			//charTokens.add(charTok);

			Line.add(charTok);
			Line.add(Double.toString(score));
			Line.add(Double.toString(coherenceScore));
			Line.add(Double.toString(globalScore));
			Line.add(cfFrag.toString());
			Line.add(synsetID);
			DefinitionList.add(Line);

			System.out.print(charTok + " : " + score + " ; " + coherenceScore);
			System.out.print(" ; " + globalScore + " ; " + cfFrag.toString());
			System.out.print(" ; " + synsetID + " ;;; ");
			System.out.print(cfFrag.getStart() + " " + cfFrag.getEnd());

			System.out.println("");
		}

		return (DefinitionList);
	}

	//BabelFy a list of string (get the senses)
	public List<List<String> > BabelFyString(List<String> inputText)
	{
		// List<SemanticAnnotation> bfyAnnotations = bfy.babelfy(inputText, Language.EN);

		List<List<String> > DefinitionList = new ArrayList<>();

		List<BabelfyToken> tokenizedInput = new ArrayList<>();
		List<SemanticAnnotation> annotationsList;

		/*
		//building tokens for the English text
		for (String word : myEnText)
			tokenizedInput.add(new BabelfyToken(word, language));

		//add an EOS token to separate the different texts
		tokenizedInput.add(BabelfyToken.EOS);
		*/

		//building tokens for the French text
		for (String word : inputText)
			tokenizedInput.add(new BabelfyToken(word, language));

		annotationsList = bfy.babelfy(tokenizedInput, language);

		for (SemanticAnnotation annotation : annotationsList)
		{
			String synsetID = annotation.getBabelSynsetID();
			double score = annotation.getScore();
			double coherenceScore = annotation.getCoherenceScore();
			double globalScore = annotation.getGlobalScore();

			String Token = new String();
			TokenOffsetFragment tfFrag = annotation.getTokenOffsetFragment();
			List<BabelfyToken> tokens = getTokens(tokenizedInput, tfFrag.getStart(), tfFrag.getEnd());

			for (BabelfyToken tok : tokens)
			{
				Token = Token + tok.getWord() + " ";
				System.out.print(tok.getWord() + " ");
			}
			Token = Token.trim();

			List<String> Line = new ArrayList<String>();

			Line.add(Token);
			Line.add(Double.toString(score));
			Line.add(Double.toString(coherenceScore));
			Line.add(Double.toString(globalScore));
			Line.add(tfFrag.toString());
			Line.add(synsetID);
			DefinitionList.add(Line);

			System.out.print(" : " + score + " ; " + coherenceScore);
			System.out.print(" ; " + globalScore + " ; " + tfFrag.toString());
			System.out.print(" ; " + synsetID + " ;;; ");
			System.out.print(tfFrag.getStart() + " " + tfFrag.getEnd());

			System.out.println("");
		}

		return (DefinitionList);
	}

	private static List<BabelfyToken> getTokens(List<BabelfyToken> tokensArray, int tfStart, int tfEnd)
	{
		List<BabelfyToken> output = new ArrayList<>();

	  if (tfStart == tfEnd)
	  {
	  	output.add(tokensArray.get(tfStart));
	  }
	  else
	  {
	    int iter_toks = tfStart;
	    while (iter_toks <= tfEnd)
	    {
	    	output.add(tokensArray.get(iter_toks));
	      iter_toks++;
	    }
	  }
	  return (output);
	}


	// Take a huuuge string (InputText), and try to cut it into small pieces.
	// Each piece length is given in CharactersPositions, however, as it does not
	// cut exactly at a space or newline, we search for the last space/newline
	// and cut exactly there. The remaining characters are given to the next
	// piece of string.
	// RealCharactersPositions (must be allocated BEFORE calling) is filled with
	// the real indexes where the string was cut.
	public static List<String> CutStringIntoStringList(String InputText,
			List<Integer> CharactersPositions, List<Integer> RealCharactersPositions)
	{
		List<String> OutList = new ArrayList<String>();
		int LastPosition = 0;
		int LastShift = 0;
		int LastCarry = 0;

		for (int CurIndex = 0; CurIndex < CharactersPositions.size(); CurIndex++)
		{
			String OutString = new String();
			String OneChar = new String();
			/*
			 * int NextShift;
			 *
			 * if ((LastPosition + CharactersPositions.get(CurIndex) + LastCarry) >
			 * InputText.length()) NextShift = InputText.length() - LastPosition; else
			 * NextShift = CharactersPositions.get(CurIndex) + LastCarry;
			 */
			int NextShift = CharactersPositions.get(CurIndex) + LastCarry;
			int NextPosition = LastPosition + NextShift;
			int RealShift = NextShift;
			int RealPosition = LastPosition + RealShift;

			RealCharactersPositions.add(LastPosition);

			// Test if end of line or not
			if (NextPosition != InputText.length())
			{
				// Not end of line
				OneChar = InputText.substring(NextPosition, NextPosition + 1);
				if (!((OneChar == " ") || (OneChar == "\n")))
				{
					// If the char where to cut is different from a space, let's calculate
					// its real position : go to the last space before the current char
					RealPosition = InputText.lastIndexOf(" ", NextPosition);
					// RealPosition = LastPosition + RealShift;
					RealShift = RealPosition - LastPosition;
					if ((RealShift == -1) || (RealPosition <= LastPosition))
					{
						RealPosition = InputText.lastIndexOf("\n", NextPosition);
						// RealPosition = LastPosition + RealShift;
						RealShift = RealPosition - LastPosition;
						if ((RealShift == -1) || (RealPosition <= LastPosition))
						{
							/////////// NEVER USED
							// If RealPosition == -1, we have the last block of terms !
							// Just get the end :)
							RealShift = NextShift;
							RealPosition = LastPosition + RealShift;
							/////////// END NEVER USED
						}
					}
				}
			}
			else
			{
				// End of line
				RealShift = NextShift;
				RealPosition = LastPosition + RealShift;
			}

			OutString = InputText.substring(LastPosition, RealPosition);

			System.out.println(OutString);
			System.out.println(OutString.length());
			System.out.println("----------");

			OutList.add(OutString);
			LastPosition += RealShift;
			LastShift = RealShift;
			LastCarry = NextShift - RealShift;
		}
		return (OutList);
	}

}
